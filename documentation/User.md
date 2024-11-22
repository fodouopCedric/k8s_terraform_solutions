### **User Instructions for Interacting with the Kubernetes Namespace **

In This section we provides detailed instructions on how users can interact with a the Terraform-based repository in order to create and manage their Kubernetes namespaces, along with an explanation of how Role-Based Access Control  works in this setup.

The primary focus of this setup is to provide users with isolated namespaces, each having specific roles and permissions that govern their access to resources within the cluster.

---

### **1. Requesting a New Namespace**

To request a new namespace, users need to interact with the Terraform configuration to define and create a new namespace for their use. 
This process is designed to be self-service, with the following workflow:

#### **Step 1: Add Your Username and Namespace to the `terraform.tfvars` file**

The **`terraform.tfvars`** file contains the list of namespaces and users that Terraform will use to configure resources. To request a new namespace:

1. clone the repository.
2. Modify the `terraform.tfvars` file by adding your username and the desired namespace name to the `usernames` and `namespace_names` lists, respectively.

##### **Example:**

If you want to create a namespace for `user5`, modify the `terraform.tfvars` file as follows:

```hcl
usernames       = ["user1", "user2", "user3", "user4", "user5"]
namespace_names = ["user1-namespace", "user2-namespace", "user3-namespace", "user4-namespace", "user5-namespace"]
role_names      = ["user1-role", "user2-role", "user3-role", "user4-role", "user5-role"]
```

#### **Step 2: Apply the Terraform Configuration**

Once the `terraform.tfvars` file is updated, the user or an administrator will apply the configuration to create the namespace. To do this, they should run the following Terraform commands from the root of the repository:

```bash
# Initialize the Terraform environment (downloads required provider plugins)
terraform init

# Apply the configuration to create the namespace and related resources
terraform apply
```

- Terraform will review the changes and ask for confirmation (`yes`).
- After applying, Terraform will create the new namespace and associated RBAC roles and role bindings.

### **2. RBAC Implementation**

Role-Based Access Control is implemented to ensure that users only have the necessary permissions for their own namespaces. The following roles and bindings are created as part of the namespace request:

- **Role**: Each user gets a `Role` created in their namespace (e.g., `user5-role` in `user5-namespace`).
- **RoleBinding**: A `RoleBinding` links the user to their specific `Role`, providing them with the necessary permissions to interact with resources within their namespace.

#### **What Does the RBAC Setup Include?**

- **Permissions**: The `Role` grants users access to resources like **pods** and **services**. By default, users are allowed to **list** and **get** resources in their namespace.
- **User Isolation**: Each user can only interact with their own namespace. This isolation is enforced by the `RoleBinding` and the namespace-specific `Role`.

#### **RBAC Configuration Example:**

For `user5` with the namespace `user5-namespace`, the following will be created by Terraform:

1. **Role (user5-role)**:
   ```hcl
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     name: user5-role
     namespace: user5-namespace
   rules:
   - apiGroups: [""]
     resources: ["pods", "services"]
     verbs: ["list", "get"]
   ```

2. **RoleBinding (user5-role-binding)**:
   ```hcl
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: user5-role-binding
     namespace: user5-namespace
   subjects:
   - kind: User
     name: user5
     namespace: user5-namespace
   roleRef:
     kind: Role
     name: user5-role
     apiGroup: rbac.authorization.k8s.io
   ```

The `Role` defines the permissions (e.g., **list** and **get** access to **pods** and **services**), while the `RoleBinding` ties those permissions to a specific user (`user5` in this case).

---


#### **Expected Outcomes After Requesting a Namespace:**

Once a namespace is requested and created:

- **Namespace Creation**: A new namespace will be available in the Kubernetes cluster with the name specified by the user (e.g., `user5-namespace`).
- **RBAC Configuration**: A `Role` and `RoleBinding` specific to the user will be created in the new namespace, ensuring the user has the appropriate permissions to interact with the namespace's resources.
- **Permissions**: The user will be able to interact with the resources within their namespace, but not with other users' namespaces.

---


### **3. Troubleshooting**

#### **Access Denied to Resources**

If you encounter an `Access Denied` error when trying to list or get resources, verify the following:

1. Ensure you're using the correct namespace with the `--namespace` flag.
2. Check that your RBAC Role and RoleBinding were created properly. You can do this by inspecting the role bindings with:

   ```bash
   kubectl get rolebindings --namespace=user5-namespace
   ```

   If the role bindings are missing or incorrectly configured, the user won't have access to the resources.

#### **Namespace Does Not Appear**

If the newly requested namespace does not appear after running `terraform apply`, ensure that the Terraform configuration has been applied successfully. Check the Terraform outputs for any errors or warnings during the apply process.

---

