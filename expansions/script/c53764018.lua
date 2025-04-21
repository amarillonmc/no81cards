local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSummonPlayer(1-tp)
end
function s.atfilter(c,att)
	return c:GetAttribute()~=att
end
function s.cfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelAbove(5) and not c:IsPublic()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,tp)
	if chk==0 then return e:IsCostChecked() and #g>0 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sg:GetFirst():RegisterEffect(e1)
	e:SetLabelObject(sg:GetFirst())
	sg:GetFirst():CreateEffectRelation(e)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetTargetsRelateToChain():Filter(Card.IsFaceup,nil)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		local att=tc:GetAttribute()
		local b1=tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1)
		local b2=#tg>0 and att>0 and tg:IsExists(s.atfilter,1,nil,att)
		if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
			if op==1 then
				local s1=tc:IsSummonable(true,nil,1)
				local s2=tc:IsMSetable(true,nil,1)
				if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then Duel.Summon(tp,tc,true,nil,1) else Duel.MSet(tp,tc,true,nil,1) end
			elseif op==2 then
				for tgc in aux.Next(tg) do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
					e1:SetValue(att)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tgc:RegisterEffect(e1)
				end
			end
		end
	end
end
