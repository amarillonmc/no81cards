if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765001
local cm=_G["c"..m]
cm.name="枷狱客服 潘德莫妮卡"
cm.Snnm_Ef_Rst=true
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1,_,_,_=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	SNNM.HelltakerActivate(c,m)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	e4:SetLabelObject(e0)
	c:RegisterEffect(e4)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0xc530) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.tyfilter,tp,0,LOCATION_ONFIELD,1,nil,tp,c:GetType()&0x7)
end
function cm.tyfilter(c,tp,typ)
	return c:IsFaceup() and c:IsType(typ) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetColumnGroup())
end
function cm.cfilter(c,g)
	return g:IsContains(c)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=tg:SelectSubGroup(tp,cm.check,false,1,3)
	if g and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		local typ=0
		for tc in aux.Next(og) do typ=typ|(tc:GetType()&0x7) end
		if typ>0 then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_FIELD)
			e0:SetCode(EFFECT_CANNOT_TO_HAND)
			e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e0:SetTargetRange(1,0)
			e0:SetTarget(cm.thlimit)
			e0:SetLabel(typ)
			e0:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e0,tp)
		end
	end
end
function cm.thlimit(e,c,tp,re)
	return c:IsType(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(m+50) or 0
	e:SetLabel(ct)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and e:GetLabelObject():GetLabel()>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabelObject():GetLabel()*1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
