--N#51 Synonymph Ignite Light
function c31021013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c31021013.batfilter)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c31021013.target)
	e2:SetOperation(c31021013.operation)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c31021013.revcon)
	e3:SetTarget(c31021013.revtg)
	e3:SetOperation(c31021013.revop)
	e3:SetCountLimit(1,31021013)
	c:RegisterEffect(e3)
	if not c31021013.global_check then
		c31021013.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DESTROYED)
		ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge:SetOperation(c31021013.descount)
		ge:SetLabel(31021013)
		Duel.RegisterEffect(ge,0)
	end
end
function c31021013.batfilter(e,c)
	return not c:IsSetCard(0x891)
end

function c31021013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetOverlayCount() > 0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c31021013.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=e:GetHandler():GetOverlayCount()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function c31021013.revcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41) == 0x41
end
function c31021013.filter(c,e)
	return c:IsSetCard(0x893) and c:IsCanBeSpecialSummoned(e,nil,tp,false,false)
end
function c31021013.revtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31021013.filter(chkc,e) end
	if chk==0 then return Duel.IsExistingTarget(c31021013.filter,tp,LOCATION_GRAVE,0,1,nil,e) and 
			Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ct=Duel.GetFlagEffectLabel(0,31021013)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE) < ct then ct=Duel.GetLocationCount(tp,LOCATION_MZONE) end
	local g=Duel.SelectTarget(tp,c31021013.filter,tp,LOCATION_GRAVE,0,1,ct,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c31021013.revop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft <= 0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if ft < sg:GetCount() then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end

function c31021013.descount(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if bit.band(r,0x41) == 0x41 then
		Duel.ResetFlagEffect(0,31021013)
		Duel.RegisterFlagEffect(0,31021013,0,0,1,eg:GetCount())
	end
end