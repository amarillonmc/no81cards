--假面骑士 空我/升华全能
local m=40020166
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40020183)
	--change name
	aux.EnableChangeCode(c,40020183,LOCATION_MZONE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
end
function cm.cfilter(c,tp,re)
	return c:IsPreviousControler(tp) and aux.IsCodeListed(c,40020183) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER) 
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp,re)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsPlayerCanDraw(tp,2) or Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil):GetCount()>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then 
		Duel.BreakEffect()
		local ck=0
		local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
		if #g>0 then ck=ck+1 end
		if Duel.IsPlayerCanDraw(tp,2) then ck=ck+2 end
		local op=0
		if ck==3 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2)) end
		if op==0 or ck==1 then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
		if op==1 or ck==2 then 
			Duel.Draw(tp,2,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end