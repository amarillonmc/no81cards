--幻叙·山神代行-朔影
function c10200118.initial_effect(c)
    c:EnableReviveLimit()
	--Special summon procedure from hand/GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c10200118.spcon)
	e1:SetOperation(c10200118.spop)
	c:RegisterEffect(e1)
	--Indestructible once per turn each by battle/effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c10200118.indtg)
	e2:SetValue(c10200118.indval)
	c:RegisterEffect(e2)
	--Change level to original and send to GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200118,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10200118.lvcon)
	e3:SetTarget(c10200118.lvtg)
	e3:SetOperation(c10200118.lvop)
	c:RegisterEffect(e3)
end
--Special summon cost filter
function c10200118.costfilter(c)
	return c:IsCode(10200116) and c:IsAbleToRemoveAsCost()
end
--Special summon condition
function c10200118.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10200118.costfilter,tp,LOCATION_GRAVE,0,1,nil)
end
--Special summon operation
function c10200118.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10200118.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--Indestructible target
function c10200118.indtg(e,c)
	return c:IsSetCard(0x838)
end
--Indestructible value
function c10200118.indval(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 then return 1 end
	if (r&REASON_EFFECT)~=0 then return 1 end
	return 0
end
--Level condition filter
function c10200118.lvconfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=c:GetOriginalLevel()
end
--Level change condition
function c10200118.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10200118.lvconfilter,tp,LOCATION_MZONE,0,1,nil)
end
--Level change target
function c10200118.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_ONFIELD)
end
--Level filter
function c10200118.lvfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
--Level change operation
function c10200118.lvop(e,tp,eg,ep,ev,re,r,rp)
	--First, calculate the level difference (before changing levels)
	local g=Duel.GetMatchingGroup(c10200118.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then return end
	
	--Calculate current total and original total for determining diff
	local current_total=0
	local original_total=0
	local tc=g:GetFirst()
	while tc do
		current_total=current_total+tc:GetLevel()
		original_total=original_total+tc:GetOriginalLevel()
		tc=g:GetNext()
	end
	local diff=math.abs(current_total-original_total)
	
	--Apply level change effect first
	tc=g:GetFirst()
	while tc do
		local orig_lv=tc:GetOriginalLevel()
		if tc:GetLevel()~=orig_lv and orig_lv>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(orig_lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	
	--Force visual update of level changes
	Duel.BreakEffect()
	
	--Wait a short moment to ensure level change is displayed
	--Then proceed with sending cards to GY
	if diff>0 then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #sg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local rg=sg:Select(tp,1,diff,nil)
			if #rg>0 then
				Duel.SendtoGrave(rg,REASON_EFFECT)
			end
		end
	end
end
