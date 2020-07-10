#################################
### Data
#################################

setwd("C:/Users/Marcelo/Desktop/Chave online/chave_familias")

read.csv("Dat_matrix.csv", row.names = 1) -> mat
read.csv("Dat_characters.csv", stringsAsFactors = F) -> char.dat
data.frame(ID=c(1:ncol(mat)), Family=colnames(mat)) -> fam

#################################
### Identificação - options
#################################

unique(char.dat$Check.box.id) -> ident.ids
vector("list", length=length(ident.ids)) -> cb.dat.id 
names(cb.dat.id) <- ident.ids
for (i in 1:length(ident.ids)) {
  ident.ids[i] -> id0
  char.dat[which(char.dat$Check.box.id == id0),] -> dat0
  dat0$Check.box.label[1] -> label0
  dat0$ID -> choices0
  dat0$Character -> names(choices0)
  list(id=id0, label=label0, choices=choices0) -> cb.dat.id[[i]]
}

#################################
### Comparação - options
#################################

fam$ID -> fam.choices
names(fam.choices) <- fam$Family
fam.choices[order(names(fam.choices))] -> fam.choices

### caracteres

unique(char.dat$Check.box.label) -> char.types.opts

#################################
### UI
#################################

ui <- fluidPage(
  navbarPage("Famílias Angiospermas (BR)", theme = shinytheme("lumen"), position="fixed-top",
             ##################################    
             ### Identificação
             ##################################
                 tabPanel("Identificação", 
                          titlePanel("Identificação"),
                          ##################################
                          ### Side Panel
                          sidebarPanel(
                            useShinyjs(),
                            titlePanel("Caracteres"),
                            helpText("Selecione os caracteres presentes no seu espécime. Conforme os caracteres são adicionados, famílias que não possuem tais características são eliminadas da lista. Na aba \"Comparação\" é possível visualizar uma tabela comparativa entre famílias selecionadas."),
                            helpText("\n", "\n"),
                            
                            ### Checkbox tree
                            
                            uiOutput("chars.tree"),
                            
                            helpText("\n", "\n"),
                            helpText(""),
                            
                            ### Buttons
                            actionButton("clean.button.1", "Limpa", icon=icon(name="thumbs-up", lib="glyphicon")),
                            helpText("\n", "\n"),
                                                       
                          ),
                          ##################################
                          ### Main Panel
                          mainPanel( 
                            titlePanel("Família(s)"),
                            helpText("\n", "\n"),
                            tabPanel("familias", tableOutput("familias.n")),
                            helpText("\n", "\n", "\n"),
                            tabPanel("familias", tableOutput("caracteres.n")),
                            helpText("\n", "\n", "\n"),
                            tabPanel("familias", tableOutput("familias.keep")),
                          )
                 ),
          ##################################
          ### Comparação
          ##################################
             tabPanel("Comparação", 
                      titlePanel("Comparação"),
                      ##################################
                      ### Side Panel
                      sidebarPanel(
                        useShinyjs(),
                        titlePanel("Famílias"),
                        helpText("Selecione 1 ou mais famílias para comparar suas características."),
                        helpText("\n", "\n"),
                        # Famílias
                        dropdown(checkboxGroupInput(inputId = "familias.sel",
                                                    label = "Famílias:",
                                                    choices = fam.choices), 
                                                    label = "Famílias"),
                        helpText("\n", "\n"),
                        
                        # Characters
                        radioButtons(inputId = "chars.sel",
                                           label = "Caracteres:",
                                           choices = c(
                                             "Distintivos" = "distintivos",
                                             "Semelhantes" = "semelhantes",
                                             "Todos" = "todos"), selected="distintivos", inline=F
                                     ),
                        helpText("\n", "\n"),
                        
                        ### Checkbox characters 
                        checkboxGroupInput(inputId = "char.type",
                                           label = "Caracteres:",
                                           choices = char.types.opts),
                        
                        ### Clean
                        actionButton("clean.button.2", "Limpa", icon=icon(name="thumbs-up", lib="glyphicon")),
                        
                        helpText("\n", "\n"),
                        helpText("")
                      ),
                      ##################################
                      ### Main Panel
                      mainPanel( 
                        titlePanel("Tabela comparativa"),
                        helpText("\n", "\n"),
                        tabPanel("table.comp", tableOutput("familias.sel.n")),
                        helpText("\n", "\n", "\n"),
                        tabPanel("table.comp", tableOutput("chars.sel.n")),
                        helpText("\n", "\n", "\n"),
                        tabPanel("table.comp", tableOutput("familias.comp")),
                        helpText("\n", "\n", "\n")
                      )
             ),
             
             ### About
             tabPanel("Sobre", fluidPage(includeMarkdown("about.Rmd")))
                 
  )
)


