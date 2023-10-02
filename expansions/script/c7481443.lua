--守墓的潜行者
local s,id,o=GetID()
function s.initial_effect(c)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tgcon)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)
	--search reg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+o)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.tgfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_GRAVE) 
	--and c:IsAbleToGrave() and not c:IsLocation(LOCATION_DECK)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.tgfilter,1,nil,tp)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --g:GetCount()>0 and 
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	--Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.in_array(b,list)
  if not list then
	return false 
  end 
  if list then
	for _,ct in pairs(list) do
	  if ct==b then return true end
	end
  end
  return false
end 
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
	local g=eg:Filter(s.tgfilter,nil,tp)
	--if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	--  Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	--end
	g:KeepAlive()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(s.distg)
	e1:SetLabelObject(g)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCondition(s.discon)
	e2:SetOperation(s.disop)
	e2:SetLabelObject(g)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local array={}
	local tc=g:GetFirst()
	while tc do
		local oc=tc:GetOriginalCode()
		if not s.in_array(oc,array) then
			array[#array+1]=oc
		end
		tc=g:GetNext()
	end
	--
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetDescription(aux.Stringid(id,3))
	ge1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SET_AVAILABLE)
	ge1:SetType(EFFECT_TYPE_SINGLE)
	local ge01=Effect.CreateEffect(e:GetHandler())
	ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	ge01:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ge01:SetTargetRange(0xff,0)
	ge01:SetTarget(s.actfilter)
	ge01:SetLabel(table.unpack(array))
	ge01:SetLabelObject(ge1)
	ge01:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(ge01,1-tp)
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetLabel(table.unpack(array))
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local ge1=Effect.CreateEffect(e:GetHandler())
	ge1:SetDescription(aux.Stringid(id,3))
	ge1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	ge1:SetType(EFFECT_TYPE_SINGLE)
	local ge01=Effect.CreateEffect(e:GetHandler())
	ge01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	ge01:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ge01:SetTargetRange(0xff,0)
	ge01:SetTarget(s.actfilter)
	ge01:SetLabel(table.unpack(array))
	ge01:SetLabelObject(ge1)
	ge01:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(ge01,1-tp)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(s.aclimit2)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)]]
end
function s.aclimit(e,re,tp)
	local array={e:GetLabel()}
	return s.in_array(re:GetHandler():GetCode(),array)
end
function s.actfilter(e,c)
	local array={e:GetLabel()}
	return s.in_array(c:GetCode(),array)
end
function s.aclimit2(e,re,tp)
	return not re:GetHandler():IsSetCard(0x2e) and re:GetActivateLocation()==LOCATION_GRAVE 
end
function s.codefilter(c,code)
	return c:GetOriginalCodeRule()==code
end
function s.distg(e,c)
	local tg=e:GetLabelObject()
	return tg:IsExists(s.codefilter,1,nil,c:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT|TYPE_SPELL|TYPE_TRAP) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local tg=e:GetLabelObject()
	return (rp==tp and not tc:IsSetCard(0x2e) and re:GetActivateLocation()==LOCATION_GRAVE) or (rp==1-tp and tg:IsExists(s.codefilter,1,nil,tc:GetOriginalCodeRule()))
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c)
	return c:IsSetCard(0x2e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
