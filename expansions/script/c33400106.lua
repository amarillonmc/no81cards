--刻刻帝 「六之弹」
function c33400106.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33400106+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c33400106.target)
	e1:SetOperation(c33400106.activate)
	c:RegisterEffect(e1)
end
function c33400106.cfilter(c,e,tp)
	return c:IsSetCard(0x3341) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33400106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.IsExistingTarget(c33400106.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end
	local sc=Duel.GetMatchingGroupCount(c33400106.cfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return sc>0  end
	local cn=Duel.GetCounter(tp,1,0,0x34f)
	local lvt={}
	for i=1,2 do
	 if (i*2)<=cn and i<=sc then lvt[i]=i  end 
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400106,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.RemoveCounter(tp,1,0,0x34f,sc1*2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33400106.cfilter,tp,LOCATION_GRAVE,0,sc1,sc1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	local v=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
end
function c33400106.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
	 while tc do 
	  if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
	  end
	 tc=g:GetNext()
	 end
	end
	Duel.SpecialSummonComplete()
	 if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c33400106.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function c33400106.splimit(e,c)
	return not c:IsSetCard(0x341)
end