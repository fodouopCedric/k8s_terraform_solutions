
### **Step-by-Step Guide to Set Up Kubernetes Infrastructure Using Terraform**

---

### **Prerequisites**

Before you start, ensure you have the following prerequisites :

1. **Minikube** set up and running on your local machine (more details in the Operator.md).
2. **kubectl** configured to communicate with your Minikube cluster.
3. **Terraform** installed on your machine.

---

### **Step 1: Create a New Directory for Your Terraform Files**

Start by creating a new directory to store your Terraform configuration files:

```bash
mkdir k8s-terraform
cd k8s-terraform
```

---

### **Step 2: Set Up the Directory Structure**

Inside your project directory (`k8s-terraform`), you will have several files and directories for modules:

```
k8s-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
    ├── user/
    │   ├── main.tf
    │   └── variables.tf
    └── user_role_binding/
        ├── main.tf
        └── variables.tf
```

---

### **Step 3: Define the Terraform Configuration Files**

#### 1. **`variables.tf`** (Define input variables for users, namespaces, and roles)

-> Create a `variables.tf` file in the root of your `k8s-terraform` directory:

This file defines the input variables that Terraform will use for configuration. 
These variables will be used by the Terraform modules to create Kubernetes namespaces, roles, and role bindings.

Explanation of the content:
usernames: A list of strings representing the usernames (or IDs) of the users who will be assigned namespaces and roles.
namespace_names: A list of strings representing the namespaces that will be created for each user.
role_names: A list of strings representing the names of roles that will be created for each user.
These variables are used  to dynamically create resources for each user. 
You can modify the default values in this file or create a terraform.tfvars file to override them.

#### 2. **`outputs.tf`** (Define the outputs for the resources created)

-> Create an `outputs.tf` file in the root directory to show the created resources after the Terraform apply:

Outputs are used here to track the created resources and returns key information about them, such as the names of created namespaces, roles, and role bindings.

Explanation of the content:
user_namespaces: This output will display the names of the namespaces that were created by the user_resources module.
user_roles: This output will display the names of the roles that were created by the user_roles_and_bindings module.
user_role_bindings: This output will display the names of the role bindings that were created by the user_roles_and_bindings module.


#### 3. **`main.tf`** (Main configuration to include modules for creating namespaces, roles, and role bindings)

-> Create a `main.tf` file in the root directory to manage the modules that create the namespaces, roles, and role bindings for each user.

This is the main configuration file that includes the Kubernetes provider setup and the module calls. 
It’s where you define how Terraform should interact with the Kubernetes cluster (via the kubernetes provider) and invoke the modules for creating resources. 

Explanation of the content:
Kubernetes Provider Configuration:
provider "kubernetes": This block configures the Kubernetes provider. 
It tells Terraform to use the Kubernetes configuration from the local Minikube cluster (~/.kube/config). 
Ensure that the config_path is correct for your environment if you are not using minikube

Modules:
The module "user_resources" block calls the user module, passing the variables usernames and namespace_names to create namespaces for each user.
The module "user_roles_and_bindings" block calls the user_role_binding module, passing the variables usernames, namespace_names, and role_names to create roles and role bindings for each user.
This file orchestrates the creation of resources by leveraging the two modules defined later.


### **Step 4: Create the Modules for User Resources**

-> Create two modules to organize the creation of namespaces, roles, and role bindings.

#### 1. **Create the `user` module** for creating namespaces

-> Create a directory `modules/user` and then add the below files:

**`modules/user/variables.tf`**

in This file we define the input variables specifically for the user module. These variables will be used to create the namespaces.
Explanation:
usernames: A list of usernames (provided by the root module) that are used to identify the users.
namespace_names: A list of namespace names (provided by the root module) where each user will have their own namespace.
These variables are used inside the user module to create namespaces for each user in the Kubernetes cluster.


**`modules/user/main.tf`**

here we define the main logic of the user module. It uses the variables passed to it from the root module to create Kubernetes namespaces.
Explanation:
kubernetes_namespace Resource:

This resource creates a namespace in Kubernetes for each entry in the namespace_names list.
The count parameter is used to loop over each item in the namespace_names list. For each entry, a new Kubernetes namespace is created.
The metadata.name is dynamically set based on the value of namespace_names[count.index].
output "namespaces":

This output returns the names of the created namespaces so that they can be displayed after applying the Terraform configuration.

This module creates Kubernetes namespaces for each user by looping over the `namespace_names` variable. 


#### 2. **Create the `user_role_binding` module** for creating roles and role bindings

-> Create a directory `modules/user_role_binding` and add the following files:

**`modules/user_role_binding/variables.tf`**

in This file we define the input variables for the user_role_binding module, which is responsible for creating roles and role bindings.
Explanation:
usernames: A list of usernames (passed from the root module) that will be used to create role bindings.
namespace_names: A list of namespaces (passed from the root module) where the roles and role bindings will be created.
role_names: A list of role names (passed from the root module) to be assigned to the users.



**`modules/user_role_binding/main.tf`**

Here we define the resources for creating roles and role bindings for each user in the corresponding namespaces.

Explanation:
kubernetes_role Resource:

This resource creates a Role for each user in the corresponding namespace. The role includes two rule blocks that allow list and get operations on pods and services.
kubernetes_role_binding Resource:

This resource creates a RoleBinding that binds each user to their respective role in the respective namespace.
Outputs:

roles: Displays the names of the roles created for each user.
role_bindings: Displays the names of the role bindings created for each user.

This module creates roles and role bindings for each user in their respective namespaces.

---

### **Step 5: Configure and Customize the Variables**

If We need to customize  users, namespaces, or roles, we can modify the `terraform.tfvars` file in the root of the project.

**`terraform.tfvars`**

```hcl
usernames       = ["user1", "user2", "user3", "user4"]
namespace_names = ["user1-namespace", "user2-namespace", "user3-namespace", "user4-namespace"]
role_names      = ["user1-role", "user2-role", "user3-role", "user4-role"]
```

we can modify the lists of usernames, namespaces, and roles as needed.

---

### **Step 6: Initialize and Apply the Terraform Configuration**

Now that you've set up the Terraform configuration files, it's time to initialize and apply the configuration.

#### 1. Initialize the Terraform Directory

```bash
terraform init
```

This command initializes the directory, downloads the necessary providers, and sets up the modules.

#### 2. Apply the Configuration

```bash
terraform apply
```

Terraform will show a plan of what resources it will create. Review the plan and type `yes` to apply the changes.

---

### **Step 7: Verify the Resources in Kubernetes**

After applying the Terraform configuration, you can verify the creation of namespaces, roles, and role bindings using `kubectl`.

- List the namespaces:

  ```bash
  kubectl get namespaces
  ```

- Verify roles in each namespace:

  ```bash
  kubectl get roles -n user1-namespace
  kubectl get roles -n user2-namespace
  kubectl get roles -n user3-namespace
  kubectl get roles -n user4-namespace
  ```

- Verify role bindings in each namespace:

  ```bash
  kubectl get rolebindings -n user1-namespace
  kubectl get rolebindings -n user2-namespace
  kubectl get rolebindings -n user3-namespace
  kubectl get rolebindings -n user4-namespace
  ```

---

### **Step 8: Clean Up**

If you want to destroy the resources that were created, you can run:

```bash
terraform destroy
```

This will remove the namespaces, roles, and role bindings from your Kubernetes cluster.

---

### **Conclusion**

This step-by-step guide has walked you through the process of creating a Kubernetes infrastructure using Terraform. You learned how to set