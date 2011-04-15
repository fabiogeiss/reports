#DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/biotec')
APP_ROOT = File.expand_path(File.dirname(__FILE__))
DataMapper.setup(:default, "sqlite://#{APP_ROOT}/db/reports.db")
#DataMapper::Model.raise_on_save_failure = true # globally

class Clientemedico
  include DataMapper::Resource
  property :clm_internal_id,    Serial, :key => true, :required => true, :unique => true
  property :clm_tipo,           Integer, :unique_index => :ux_idx_cm
  property :clm_codigocrm,      Integer, :required => true, :unique_index => :ux_idx_cm
  property :clm_nomefantasia,   String, :length => 100
  property :clm_razaosocial,    String, :length => 100  
  property :clm_especialidade,  String, :length => 50  
  property :clm_endereco,       String, :length => 200
  property :clm_bairro,         String, :length => 100
  property :clm_cidade,         String, :length => 100
  property :clm_uf,             String, :length => 2
  property :clm_telefone,       String, :length => 15
  property :clm_email,          String, :length => 200, :format => :email_address, :message => "Email inválido!"
  property :clm_secretaria,     String, :length => 50
  has n, :visitas

  validates_uniqueness_of :clm_codigocrm, :scope => :clm_tipo , :message => "Código/CRM já existente!"	
end

class Visita
  include DataMapper::Resource
  property :vis_internal_id,  Serial,  :key => true
  property :vis_data,         Date,    :required => true
  property :vis_comentarios,  Text,    :required => true
  belongs_to :clientemedico, :required => true
end

DataMapper.finalize

#DataMapper.auto_migrate!
#DataMapper.auto_upgrade!



