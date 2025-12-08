--幻叙渲染师 - 纳诺
local s,id,o=GetID()
function s.initial_effect(c)
	-- Special Summon both
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	-- Attribute copy, recycle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.attrtg)
	e2:SetOperation(s.attrop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOwnerPlayer(tp)
	e0:SetValue(s.matval)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.eftg)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
end
function s.matval(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
function s.eftg(e,c)
	return c:GetAttribute()&e:GetHandler():GetAttribute()>0
end
function s.cfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and not c:IsPublic() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,sc)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)
	e:SetLabelObject(sc)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Group.FromCards(c,tc)
	local fg=g:Filter(Card.IsRelateToChain,nil)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if fg:GetCount()~=2 then return end
	Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
end
function s.attrfilter(c,e)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function s.attcheck(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function s.attrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(s.attrfilter,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.attrfilter(chkc) end
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,s.attcheck,false,1,6)
	Duel.SetTargetCard(sg)
end
function s.attrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain()
	for tc in aux.Next(g) do
		local att=tc:GetAttribute()
		if c:GetAttribute()&att>0 and c:IsFaceup() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				-- Add attribute
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_ADD_ATTRIBUTE)
				e1:SetValue(att)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
			end
		end  
	end
end
