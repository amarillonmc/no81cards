--医生悠悠
local m=79630010
local set=0x183
local YUU=27288416
local cm=_G["c"..m]
function cm.initial_effect(c)
	--code
	aux.EnableChangeCode(c,YUU,LOCATION_ONFIELD+LOCATION_GRAVE)
	--特召1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--特召2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
--特召1
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp)
		return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
			and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
	end,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
		return eg:IsExists(function(tc)
			return tc:GetPreviousControler()==tp and tc:IsPreviousLocation(LOCATION_MZONE)
				and (tc:IsReason(REASON_BATTLE) or tc:IsReason(REASON_EFFECT))
		end,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tg=eg:FilterSelect(tp, function(tc)
		return tc:GetPreviousControler()==tp and tc:IsPreviousLocation(LOCATION_MZONE)
			and (tc:IsReason(REASON_BATTLE) or tc:IsReason(REASON_EFFECT))
	end,1,1,nil)
	if #tg>0 then
		local atk=tg:GetFirst():GetPreviousAttackOnField()
		if not atk or atk<0 then atk=0 end
		e:SetLabel(atk)
		Duel.SetTargetCard(tg)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local atk=e:GetLabel() or 0
	if atk<0 then atk=0 end
	if atk>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
--特召2
function cm.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end