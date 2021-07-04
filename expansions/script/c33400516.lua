--四糸乃 冰冷之花
local m=33400516
local cm=_G["c"..m]
function cm.initial_effect(c)
 --fusion materia
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,cm.fusfilter1,cm.fusfilter2)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)   
	--pendulum set
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetTarget(cm.pentg1)
	e0:SetOperation(cm.penop1)
	c:RegisterEffect(e0)
 --counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.ctcon)
	e1:SetTarget(cm.cttg)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCost(cm.cost)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
end
function cm.fusfilter1(c)
	return c:IsSetCard(0x341)
end
function cm.fusfilter2(c)
	return c:IsType(TYPE_PENDULUM) or c:IsAttribute(ATTRIBUTE_WATER)
end

function cm.pcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) and not c:IsCode(m) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.pentg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.penop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function cm.ckfilter(c)
	return c:IsSetCard(0x3344) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) or Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	if not Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)then Duel.PayLPCost(tp,1000)
	end
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) 
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x341) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(8)
end
function cm.tgfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x341) and c:IsAbleToHand() and c:IsType(TYPE_RITUAL)
end
function cm.thfilter3(c)
	return ((c:IsType(TYPE_MONSTER)   and c:IsType(TYPE_RITUAL) and c:IsLevelBelow(8)) or  (c:IsType(TYPE_SPELL)  and c:IsType(TYPE_RITUAL)) )and c:IsSetCard(0x341) and c:IsAbleToHand()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) or Duel.IsExistingMatchingCard(cm.tgfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.thfilter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g1:GetCount()==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=g1:SelectSubGroup(tp,cm.check,false,1,2) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.check(g,c)
	if #g==1 then return true end
	local res=0
	if #g==2 then 
	if g:IsExists(cm.tgfilter,1,nil,c) then res=res+1 end
	if g:IsExists(cm.tgfil,1,nil,c) then res=res+4 end
	return res==5 
	end
end

function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() 
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) or (Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1))end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) and not (Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1)) then return end
	local c=e:GetHandler()
	local b1=0
	local b2=0
	local op
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then b1=1 end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x1015,1) then b2=1 end 
	if b1==1 and b2==1 then  
			op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))				 
	elseif b1==1 then
		op=0	 
	else
		op=1	  
	end
	if c:IsRelateToEffect(e) and op==0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	if op==1 then 
	 local g1=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1015,1)
	   for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tc=g1:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1015,1)
	   end  
	end
end