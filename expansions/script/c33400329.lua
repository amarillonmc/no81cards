--D.A.L BEAST 夜刀神十香
local m=33400329
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
 --spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
  --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.sprcon)
	e2:SetOperation(cm.spop0)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
--im
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter1)
	c:RegisterEffect(e4)
 --cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
  --indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
 --cannot release
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UNRELEASABLE_SUM)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e9)
 --cannot remove
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(EFFECT_CANNOT_REMOVE)
	e10:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e10)
--
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e11:SetValue(cm.fuslimit)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e12:SetValue(1)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e14)
 --pierce
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e15)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_FIELD)
		ge2:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x5341) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m)==0 then 
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),33400329,0,0,0)	   
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(m,2))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tc:GetSummonPlayer())
	  --	Duel.Recover(tp,20,REASON_EFFECT)
		end
		tc=eg:GetNext()
	end
end

function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousPosition()&POS_FACEUP~=0 and tc:IsType(TYPE_MONSTER) then 
			if tc:IsSetCard(0x5341) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+1)==0 then 
			Duel.RegisterFlagEffect(tp,33400330,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,12))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
		   -- Duel.Recover(tp,10,REASON_EFFECT)
			end
			if tc:IsSetCard(0x5342) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+2)==0 then 
			Duel.RegisterFlagEffect(tp,33400331,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,3))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
		  --  Duel.Recover(tp,1,REASON_EFFECT)
			end
			if tc:IsSetCard(0x6342)and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+3)==0 then 
			Duel.RegisterFlagEffect(tp,33400332,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,4))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,2,REASON_EFFECT)
			end
			if tc:IsSetCard(0x3341)and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+4)==0 then 
			Duel.RegisterFlagEffect(tp,33400333,0,0,0)
			  local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,5))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,3,REASON_EFFECT)
			end
			if tc:IsSetCard(0x6341)and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+5)==0 then 
			Duel.RegisterFlagEffect(tp,33400334,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,6))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,4,REASON_EFFECT)
			end
			if tc:IsSetCard(0x9341) and tc:GetOriginalAttribute()==ATTRIBUTE_FIRE and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+6)==0 then 
			Duel.RegisterFlagEffect(tp,33400335,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,7))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,5,REASON_EFFECT)
			end
			if tc:IsSetCard(0x9342)and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+7)==0 then 
			Duel.RegisterFlagEffect(tp,33400336,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,8))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,6,REASON_EFFECT)
			end
			if tc:IsSetCard(0x3342) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+8)==0 then 
			Duel.RegisterFlagEffect(tp,33400337,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,9))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
		   --   Duel.Recover(tp,7,REASON_EFFECT)
			end
			if tc:IsSetCard(0xa341) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+9)==0 then 
			Duel.RegisterFlagEffect(tp,33400338,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,10))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,8,REASON_EFFECT)
			end
			if tc:IsSetCard(0xc341) and  Duel.GetFlagEffect(tc:GetSummonPlayer(),m+10)==0 then 
			Duel.RegisterFlagEffect(tp,33400339,0,0,0)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,11))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,0)
			Duel.RegisterEffect(e3,tp)
			--  Duel.Recover(tp,9,REASON_EFFECT)
			end
		end
		tc=eg:GetNext()
	end
end

function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_DECK,0,nil)
	return Duel.GetFlagEffect(tp,33400329)>0 and 
	Duel.GetFlagEffect(tp,33400330)>0 and 
	Duel.GetFlagEffect(tp,33400331)>0 and 
	Duel.GetFlagEffect(tp,33400332)>0 and 
	Duel.GetFlagEffect(tp,33400333)>0 and 
	Duel.GetFlagEffect(tp,33400334)>0 and 
	Duel.GetFlagEffect(tp,33400335)>0 and 
	Duel.GetFlagEffect(tp,33400336)>0 and 
	Duel.GetFlagEffect(tp,33400337)>0 and 
	Duel.GetFlagEffect(tp,33400338)>0 and 
	Duel.GetFlagEffect(tp,33400339)>0 and 
	g:GetClassCount(Card.GetCode)==g:GetCount()
	and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	local hg=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	Duel.ConfirmCards(tp,hg)
	Duel.ConfirmCards(1-tp,hg)
end

function cm.con(e,tp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
--tograve
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoGrave(g,REASON_RULE+REASON_EFFECT)
--todeck
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,nil) and  Duel.SelectYesNo(tp,aux.Stringid(m,0))then
	local rg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,nil)
	local tdg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_REMOVED+LOCATION_GRAVE,LOCATION_REMOVED+LOCATION_GRAVE,1,rg:GetCount(),nil)
	Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT)
	end
--ac
	 local ctg=Duel.GetMatchingGroup(cm.acfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,tp)
	   if ctg:GetCount()>0 then
		  local tc=ctg:Select(tp,1,1,nil):GetFirst()
		  if tc then
			 Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			 local te=tc:GetActivateEffect()
			 local tep=tc:GetControler()
			 local cost=te:GetCost()
			 if cost then
				cost(te,tep,eg,ep,ev,re,r,rp,1) 
			 end
		  end
	   end
 --cannot inactivate/disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetValue(cm.efilter)
	e4:SetLabel(ac)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e5,tp)
  --
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetProperty(EFFECT_CANNOT_DISEFFECT)
	e2:SetOperation(cm.thop)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,33420330,0,0,1)
end
function cm.acfilter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:GetActivateEffect():IsActivatable(tp) and c:IsSetCard(0x9340)
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsSetCard(0x341,0x340)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x9340) and c:GetType()==0x20002
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,m+10000)~=0 then return end
	if not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)  then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b1 and (not b2 or Duel.SelectOption(tp,1190,1150)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
  Duel.RegisterFlagEffect(tp,m+10000,RESET_PHASE+PHASE_END,0,1)
end

function cm.efilter1(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end