--绝对辣鸡领域
function c10173044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c10173044.tg)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c10173044.tg2)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTarget(c10173044.tg3)
	c:RegisterEffect(e4)
	--Field ID
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(10173044)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsStatus,STATUS_SPSUMMON_TURN))
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e5:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(10173144)
	c:RegisterEffect(e6)
	if not c10173044.global_check then
		c10173044.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c10173044.checkop)
		Duel.RegisterEffect(ge1,0)
   end
end
function c10173044.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc,sumtype,pre,f1,f2,mg=eg:GetFirst(),0,0
	while tc do
	   mg,sumtype,pre,tpc=tc:GetMaterial(),tc:GetSummonType(),tc:GetPreviousLocation(),tc:GetControler()
	   if tc:IsType(TYPE_FUSION) then
		  if bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION or not re or not re:IsActiveType(TYPE_SPELL) or mg:GetCount()<=0 or mg:IsExists(c10173044.cfilter,1,nil,0) or pre~=LOCATION_EXTRA then 
			 tc:RegisterFlagEffect(10173044,RESET_EVENT+0x1fc0000,0,0)
		  end
	   elseif tc:IsType(TYPE_RITUAL) then
		  if bit.band(sumtype,SUMMON_TYPE_RITUAL)~=SUMMON_TYPE_RITUAL or not re or bit.band(re:GetActiveType(),0x82)~=0x82 or mg:GetCount()<=0 or mg:IsExists(c10173044.cfilter,1,nil,1) or pre~=LOCATION_HAND then 
			 tc:RegisterFlagEffect(10173044,RESET_EVENT+0x1fc0000,0,0)
		  end
	   elseif tc:IsType(TYPE_SYNCHRO) then
		  if bit.band(sumtype,SUMMON_TYPE_SYNCHRO)~=SUMMON_TYPE_SYNCHRO or mg:GetCount()<=1 or mg:IsExists(c10173044.cfilter,1,nil,2) or pre~=LOCATION_EXTRA then 
			 tc:RegisterFlagEffect(10173044,RESET_EVENT+0x1fc0000,0,0)
		  end
	   elseif tc:IsType(TYPE_XYZ) then
		  if bit.band(sumtype,SUMMON_TYPE_XYZ)~=SUMMON_TYPE_XYZ or mg:GetCount()<=1 or mg:IsExists(c10173044.cfilter,1,nil,2) or pre~=LOCATION_EXTRA then 
			 tc:RegisterFlagEffect(10173044,RESET_EVENT+0x1fc0000,0,0)
		  end
	   end
	   f1,f2=Duel.GetFieldCard(tpc,LOCATION_SZONE,5),Duel.GetFieldCard(1-tpc,LOCATION_SZONE,5)
	   if tc:IsHasEffect(10173144) then 
		  f1:CreateRelation(tc,RESET_EVENT+0x5fe0000)
	   end
	   if tc:IsHasEffect(10173044) then 
		  f2:CreateRelation(tc,RESET_EVENT+0x5fe0000)
	   end	 
	tc=eg:GetNext()
	end
end
function c10173044.tg3(e,c)
   return c10173044.tg(e,c) and c:IsStatus(STATUS_SPSUMMON_TURN) and e:GetHandler():IsRelateToCard(c)
end
function c10173044.tg2(e,c)
   return c10173044.tg(e,c) and (not c:IsStatus(STATUS_SPSUMMON_TURN) or not c:IsRelateToCard(e:GetHandler()))
end
function c10173044.tg(e,c)
   return c:GetFlagEffect(10173044)~=0 and c:IsType(TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)
end
function c10173044.cfilter(c,ct)
   local loc=LOCATION_HAND+LOCATION_MZONE 
   if ct==2 then loc=LOCATION_MZONE end
   return not c:IsPreviousLocation(loc) or (ct==1 and not c:IsReason(REASON_RELEASE))
end