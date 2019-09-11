--自由佣兵的剑士·琪露诺
function c9950037.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950037,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c9950037.destg)
	e2:SetOperation(c9950037.desop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950037,4))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,9950037)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c9950037.rmtg)
	e3:SetOperation(c9950037.rmop)
	c:RegisterEffect(e3)
	--destroy and summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950037,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,9950037)
	e3:SetCondition(c9950037.spcon)
	e3:SetCost(c9950037.spcost)
	e3:SetTarget(c9950037.sptg)
	e3:SetOperation(c9950037.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c9950037.spcon2)
	c:RegisterEffect(e4)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950037.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950037.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
end
function c9950037.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c1=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c2=Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if (c1>c2 and c2~=0) or c1==0 then c1=c2 end
	if c1~=0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,c1,0,0)
	end
end
function c9950037.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	if g1:GetCount()>0 or g2:GetCount()>0 then
		if g1:GetCount()==0 then
			Duel.Destroy(g2,REASON_EFFECT)
		elseif g2:GetCount()==0 then
			Duel.Destroy(g1,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,0)
			local ac=Duel.SelectOption(tp,aux.Stringid(9950037,2),aux.Stringid(9950037,3))
			if ac==0 then Duel.Destroy(g1,REASON_EFFECT)
			else Duel.Destroy(g2,REASON_EFFECT) end
		end
	end
end
function c9950037.desfilter(c,g)
	return g:IsContains(c)
end
function c9950037.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c9950037.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c9950037.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c9950037.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950037,0))
		end
	end
end
function c9950037.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c9950037.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9950037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,900) end
	Duel.PayLPCost(tp,900)
end
function c9950037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9950037.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(900)
		c:RegisterEffect(e1)
	end
end