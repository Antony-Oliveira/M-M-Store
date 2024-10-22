public class ProductController {
    
 @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProductsWithImage() {
        List<ProductWrapper> productsWithImages = new List<ProductWrapper>();

        List<Produto__c> produtos = [SELECT Id, Name, SKU__c, preco__c, estoque__c FROM Produto__c];

        if (produtos.isEmpty()) {
            return productsWithImages;
        }

 
        String defaultImageUrl = 'https://curious-hawk-pc3lpv-dev-ed.trailblaze.lightning.force.com/sfc/servlet.shepherd/document/download/069bm000004acOjAAI';

        for (Produto__c produto : produtos) {
            String imageUrl = defaultImageUrl;

            List<ContentDocumentLink> docLinks = [SELECT ContentDocumentId  FROM ContentDocumentLink WHERE LinkedEntityId = :produto.Id];

            if (!docLinks.isEmpty()) {
                ContentDocumentLink link = docLinks[0];
                Id contentDocumentId = link.ContentDocumentId;

                List<ContentVersion> versions = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId AND IsLatest = true];

                if (!versions.isEmpty()) {
                    ContentVersion version = versions[0];
                    imageUrl = URL.getOrgDomainUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + version.Id;
                }
            }

            productsWithImages.add(new ProductWrapper(produto, imageUrl));
        }

        return productsWithImages;
    }

   
     public class ProductWrapper {
            @AuraEnabled public Produto__c produto { get; set; }
            @AuraEnabled public String imageUrl { get; set; }
    
            public ProductWrapper(Produto__c produto, String imageUrl) {
                this.produto = produto;
                this.imageUrl = imageUrl;
            }
        }
}