--H.P.T.-004
local m=12899008
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --act in set turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
  --copy effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+10000)
	e3:SetTarget(cm.cptg)
	e3:SetOperation(cm.cpop)
	c:RegisterEffect(e3)
end
function cm.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end

function cm.tgfilter(c,e,tp)
	return c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0 and c:IsReleasableByEffect(e)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttack())
end
function cm.spfilter(c,e,tp,atk)
	return c:IsSetCard(0x5a71) and c:IsAttackBelow(atk)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then  
		return   Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	end
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc,e,tp) end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetMZoneCount(tp,tc)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsReleasableByEffect(e) then
		local atk=tc:GetAttack()
		if Duel.Release(tc,REASON_EFFECT)~=0 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,atk)
			local tc=g:GetFirst()
			if tc and  Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then  
				 if Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil)>0 and  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				 Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
				 end  
			end
		 
		end
	end
end

function cm.filter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.filter2(c)
	return ((c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and re:GetHandler():IsSetCard(0x5a71,0x6a71) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_HAND) and (not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_MZONE,0,1,nil))
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
   local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x5a71)
end

function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return  end
   --TYPE_CONTINUOUS
end
function cm.cpfilter(c)
	return c:IsSetCard(0x6a71) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_CONTINUOUS) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	local g1=g
	g1:AddCard(e:GetHandler())
	Duel.Remove(g1,POS_FACEUP,REASON_COST)  
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
