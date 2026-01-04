TESTING PLAN: 
The purpose of this testing plan is to validate that the automated infrastructure
deployment implemented using Terraform works as expected, is reproducible, and
meets functional and non-functional requirements.

1. Infrastructure Deployment Test
   Objective:
   To verify that the infrastructure can be deployed automatically and consistently.

   Test Steps:
   - Run terraform init to initialize the working directory.
   - Run terraform plan to validate the execution plan.
   - Run terraform apply to deploy the infrastructure.

   Expected Result:
   - All resources are created successfully without errors.
   - Terraform reports successful completion.

2. Resource Validation Test
   Objective:
   To ensure that all Azure resources are created correctly.

   Test Steps:
   - Verify resource groups, virtual networks, subnets, and virtual machines
     in the Azure Portal.
   - Validate that each VM is placed in the correct subnet.

   Expected Result:
   - All resources exist and match the Terraform configuration.

3. Network Connectivity Test
   Objective:
   To validate correct network segmentation and connectivity.

   Test Steps:
   - Check private IP address assignments for each virtual machine.
   - Verify Network Security Group rules are applied correctly.

   Expected Result:
   - VMs receive private IP addresses from correct subnets.
   - Network access is restricted according to security rules.

4. Logging and Monitoring Test
   Objective:
   To ensure that monitoring and logging are properly configured.

   Test Steps:
   - Query Azure Activity Logs using Log Analytics.
   - Query performance metrics (CPU, memory) from virtual machines.
   - Query Syslog entries and filter by severity.

   Expected Result:
   - Infrastructure activities appear in Activity Logs.
   - Performance metrics are collected for all virtual machines.
   - System logs are available for troubleshooting.

5. Alerting Test
   Objective:
   To validate alerting functionality.

   Test Steps:
   - Configure CPU utilization alert (>80%).
   - Verify alert rule creation and action group configuration.

   Expected Result:
   - Alert rule is successfully created and visible in Azure Monitor.
   - Notifications are triggered when conditions are met.

Conclusion:
Successful completion of all test cases confirms that the automated infrastructure
deployment is functional, observable, and suitable for enterprise environments.
--------------------------------------------------------------------------------------------------
REPORT: Infrastructure Automated Deployment
This project implements an automated cloud infrastructure deployment using
Infrastructure as Code (IaC) principles and Terraform on Microsoft Azure.

Terraform was selected as the automation tool due to its declarative syntax,
idempotent execution model, and strong support for Azure resources. The entire
infrastructure can be reproduced consistently across environments using the
same configuration files.

The deployment process consists of the following stages:
1. Initialization (terraform init), which downloads required providers and
   prepares the backend.
2. Planning (terraform plan), which generates and validates the execution plan.
3. Deployment (terraform apply), which provisions all defined resources.

The infrastructure includes multiple virtual machines deployed in isolated
subnets within a virtual network, along with network security controls,
routing, and supporting Azure services. This modular design improves
maintainability and scalability.

State management is handled using Terraform state files, which are excluded
from version control to prevent sensitive data exposure. This follows industry
best practices for secure infrastructure automation.

To ensure observability, Azure Monitor and Log Analytics Workspace were
integrated into the deployment. Infrastructure activities are captured using
Azure Activity Logs, while system-level and performance logs are collected
from virtual machines. This enables real-time monitoring, auditing, and
effective troubleshooting.

The automated deployment approach reduces manual configuration errors,
improves deployment speed, and ensures consistency across environments.
This solution demonstrates a production-ready, enterprise-grade infrastructure
automation strategy.
