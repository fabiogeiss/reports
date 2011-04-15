require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'models'

get '/' do
  redirect '/visitas'
end

get '/visitas' do
  @visitas = Visita.all(:order => [:vis_data.desc])
  erb :visitaList
end

get '/visita/new' do
  @visita = Visita.new
  @visita.vis_data=Date.today
  @visita.clientemedico=Clientemedico.new
  @clientemedico_list=Clientemedico.all(:order => [ :clm_razaosocial.asc ]) 
  erb :visita
end

post '/visita/new' do
  @visita = Visita.create(
    :vis_data=>Date.strptime(params[:data], "%d/%m/%Y"),
    :vis_comentarios=>params[:comentarios],
    :clientemedico => Clientemedico.get(params[:idclientemedico])
  )
  if not @visita.saved?
    @errors = ''
    @visita.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :visita
  else 
    redirect '/visitas'
  end
end

get '/visita/:id' do
  @visita=Visita.get(params[:id])
  @clientemedico_list=Clientemedico.all(:order => [ :clm_razaosocial.asc ])
  erb :visita
end

post '/visita/:id' do
  @visita=Visita.get(params[:id])
  if not @visita.update(
    :vis_data => Date.strptime(params[:data], "%d/%m/%Y"),
    :vis_comentarios => params[:comentarios],
    :clientemedico => Clientemedico.get(params[:idclientemedico])
  )
    @errors = ''
    @visita.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :visita
  else
    redirect "/visitas"
  end
end

get '/visita/delete/:id' do  
  @visita=Visita.get(params[:id])
  @visita.destroy
  redirect '/visitas'
end

get '/cliente/new' do
  @cliente = Clientemedico.new
  @cliente.clm_codigocrm = Clientemedico.last(:clm_tipo => 0, :order => [:clm_codigocrm.asc]).clm_codigocrm + 1
  erb :cliente
end

post '/cliente/new' do
  @cliente = Clientemedico.create(
    :clm_tipo=>params[:tipo],
    :clm_codigocrm=>params[:codigocrm],
    :clm_nomefantasia=>params[:nomefantasia],
    :clm_razaosocial=>params[:razaosocial],
    :clm_endereco=>params[:endereco],
    :clm_bairro=>params[:bairro],
    :clm_cidade=>params[:cidade],
    :clm_uf=>params[:uf],
    :clm_telefone=>params[:telefone],
    :clm_email=>params[:email]
  )
  if not @cliente.saved?
    @errors = ''
    @cliente.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :cliente
  else 
    redirect '/clientes'
  end
end

get '/cliente/delete/:id' do  
  @cliente=Clientemedico.get(params[:id])
  if Visita.first(:clientemedico => @cliente) # count > 0 
    @errors = 'Cliente possui visitas e não pode ser excluído.'
    @clientes=Clientemedico.all(:clm_tipo => 0, :order => [ :clm_razaosocial.asc ])
    erb :clienteList 
  else
    @cliente.destroy
    redirect '/clientes'
  end
end

get '/cliente/:id' do
  @cliente=Clientemedico.get(params[:id])
  erb :cliente
end

post '/cliente/:id' do
  @cliente = Clientemedico.get(params[:id]) 
  if not @cliente.update(
    :clm_codigocrm => params[:codigocrm],
    :clm_nomefantasia => params[:nomefantasia],
    :clm_razaosocial => params[:razaosocial],
    :clm_endereco => params[:endereco],
    :clm_bairro => params[:bairro],
    :clm_cidade => params[:cidade],
    :clm_uf => params[:uf],
    :clm_telefone => params[:telefone],
    :clm_email => params[:email]
  )
    @errors = ''
    @cliente.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :cliente
  else 
    redirect '/clientes'  
  end
end

get '/clientes' do
  @clientes=Clientemedico.all(:clm_tipo => 0, :order => [ :clm_razaosocial.asc ])
  erb :clienteList
end

get '/medico/new' do
  @medico = Clientemedico.new
  erb :medico
end

post '/medico/new' do
  @medico = Clientemedico.create(
    :clm_tipo=>params[:tipo],
    :clm_codigocrm=>params[:codigocrm],
    :clm_nomefantasia=>params[:nomefantasia],
    :clm_especialidade=>params[:especialidade],
    :clm_secretaria=>params[:secretaria],
    :clm_endereco=>params[:endereco],
    :clm_bairro=>params[:bairro],
    :clm_cidade=>params[:cidade],
    :clm_uf=>params[:uf],
    :clm_telefone=>params[:telefone],
    :clm_email=>params[:email]
  )
  if not @medico.saved?
    @errors = ''
    @medico.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :medico
  else 
    redirect '/medicos'
  end
end

get '/medico/delete/:id' do
  @medico=Clientemedico.get(params[:id])
  if Visita.first(:clientemedico => @medico)  
    @errors = 'Médico possui visitas e não pode ser excluído.'
  else
    @medico.destroy
  end
  redirect '/medicos'
end

get '/medico/:id' do
  @medico=Clientemedico.get(params[:id])
  erb :medico
end

post '/medico/:id' do
  @medico = Clientemedico.get(params[:id])  
  if not @medico.update(
    :clm_tipo => params[:tipo],
    :clm_codigocrm => params[:codigocrm],
    :clm_nomefantasia => params[:nomefantasia],
    :clm_especialidade => params[:especialidade],
    :clm_secretaria => params[:secretaria],
    :clm_endereco => params[:endereco],
    :clm_bairro => params[:bairro],
    :clm_cidade => params[:cidade],
    :clm_uf => params[:uf],
    :clm_telefone => params[:telefone],
    :clm_email => params[:email]
  )
    @errors = ''
    @medico.errors.each do |e|
      @errors = @errors + e.to_s + '<br/>' 
    end
    erb :medico
  else 
    redirect '/medicos'  
  end
end

get '/medicos' do
  @medicos=Clientemedico.all(:clm_tipo => 1, :order => [ :clm_nomefantasia.asc ])
  erb :medicoList
end

# exibe form de importação de CSVs
get '/import' do
  erb :import
end

get '/import/medico' do
  
  Clientemedico.all(:clm_tipo => 1).destroy
     
  medicosimp = File.open("medicos.csv")
  medicosimp.each do |m|
    row = m.split(";")
    newrow = Clientemedico.new()
    newrow.clm_tipo = 1
    newrow.clm_cidade = 'PORTO ALEGRE'
    newrow.clm_uf = 'RS'
    if row[0].length > 0 then 
      newrow.clm_nomefantasia = row[0].upcase
      newrow.clm_razaosocial = row[0].upcase
    end
    if row[1].length > 0 then newrow.clm_codigocrm = row[1]            end
    if row[2].length > 0 then newrow.clm_especialidade = row[2].upcase end
    if row[3].length > 0 then newrow.clm_endereco = row[3].upcase      end
    if row[4].length > 0 then newrow.clm_telefone = row[4]             end
    if row[5].length > 0 then newrow.clm_secretaria = row[5].upcase    end
    if row[6].length > 0 then newrow.clm_email = row[6].upcase         end
    newrow.save
  end
  redirect '/import'
end

get '/import/cliente' do
  
  Clientemedico.all(:clm_tipo => 0).destroy
     
  clientesimp = File.open("clientes.csv")
  clientesimp.each do |c|
    row = c.split(";")
    newrow = Clientemedico.new()
    newrow.clm_tipo = 0
    if row[0].length > 0 then newrow.clm_codigocrm = row[0]            end
    if row[1].length > 0 then newrow.clm_razaosocial = row[1].upcase   end
    if row[2].length > 0 then newrow.clm_endereco = row[2].upcase      end
    if row[3].length > 0 then newrow.clm_bairro = row[3].upcase        end
    if row[4].length > 0 then newrow.clm_cidade = row[4].upcase        end
    if row[5].length > 0 then newrow.clm_uf = row[5].upcase            end
    if row[6].length > 0 then newrow.clm_telefone = row[6]             end
    newrow.save
  end
  redirect '/import'
end

get '/weekreports' do
  @initialdate = Date.today - 10
  @finaldate = Date.today + 1
  @visitasweek = Visita.all(:vis_data => (@initialdate..@finaldate))  

  erb :weekreport
end

post '/weekreports' do
  @initialdate = Date.strptime(params[:datainicial], "%d/%m/%Y")
  @finaldate = Date.strptime(params[:datafinal],"%d/%m/%Y")
  @visitasweek = Visita.all(:vis_data => (@initialdate.to_s..@finaldate.to_s), :order =>[:vis_data.asc])  
  erb :weekreport
end


  
