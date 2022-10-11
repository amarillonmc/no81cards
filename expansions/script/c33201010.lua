--死魂狂热信徒
local s,id,o=GetID()
MJ_VHisc=MJ_VHisc or {}
function s.initial_effect(c)
	aux.AddCodeList(c,33201009)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(MJ_VHisc.tg)
	e1:SetOperation(MJ_VHisc.op)
	c:RegisterEffect(e1)
	--MJW
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end


function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

--e2
function s.refilter2(c,lv,slv)
	if lv>=slv then
		return c:IsFaceup() and c:IsCode(33201009) and c:IsReleasable()
	else 
		return c:IsFaceup() and c:IsCode(33201009) and c:IsReleasable() and c:IsLevelAbove(slv-lv)
	end
end
function s.ckfilter(c,e,tp,lv)
	return c:IsFacedown() and c:IsSetCard(0x932a) and c:IsLevelBelow(lv) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local lv=s.lvck(tp)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local lv=s.lvck(tp)
	if Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(s.ckfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) then   
		local sc=Duel.SelectMatchingCard(tp,s.ckfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv):GetFirst()
		local slv=sc:GetLevel()
		local rc1=Duel.SelectMatchingCard(tp,MJ_VHisc.refilter1,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
		local rlv1=rc1:GetLevel()
		local rg=Duel.SelectMatchingCard(tp,s.refilter2,tp,LOCATION_ONFIELD,0,1,1,rc1,rlv1,slv)
		rg:Merge(rc1)
		if Duel.Release(rg,REASON_EFFECT)==2 then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.lvck(tp)
	local rg=Duel.GetMatchingGroup(MJ_VHisc.refilter1,tp,LOCATION_ONFIELD,0,nil)
	if rg:GetCount()<2 then return 0 end
	local lv=0
	local mg1,mlv1=rg:GetMaxGroup(Card.GetLevel)
	if mg1:GetCount()>1 then 
		lv=mlv1*2
	else
		rg:RemoveCard(mg1)
		local mg2,mlv2=rg:GetMaxGroup(Card.GetLevel)
		lv=mlv1+mlv2
	end
	return lv
end

-------Functions and Filters-------
function MJ_VHisc.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function MJ_VHisc.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK,0,nil,RACE_ZOMBIE)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local seq=-1
	local tc=g:GetFirst()
	local tgcard=nil
	if tc then
		while tc do
			if tc:GetSequence()>seq then
				seq=tc:GetSequence()
				tgcard=tc
			end
			tc=g:GetNext()
		end
		if seq==-1 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,dcount-seq)
		if Duel.SendtoGrave(tgcard,REASON_EFFECT) and tgcard:IsLocation(LOCATION_GRAVE) then
			local token=Duel.CreateToken(tp,33201009)
			Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local lv=tgcard:GetOriginalLevel()
			if lv>12 then lv=12 end
			if lv<1 then lv=1 end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(lv)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
			token:RegisterEffect(e2,true)
			token:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201009,lv))
		end
		Duel.ShuffleDeck(tp)
	else 
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
	end
end

--SPSM from grave
function MJ_VHisc.refilter1(c)
	return c:IsFaceup() and c:IsCode(33201009) and c:IsReleasable() 
end
function MJ_VHisc.refilter2(c,lv)
	return c:IsFaceup() and c:IsCode(33201009) and c:IsReleasable() and c:IsLevelAbove(lv)
end
function MJ_VHisc.spfilter(c,e,tp)
	local rg=Duel.GetMatchingGroup(MJ_VHisc.refilter1,tp,LOCATION_ONFIELD,0,nil)
	local mg,mlv=rg:GetMaxGroup(Card.GetLevel)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(mlv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function MJ_VHisc.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and MJ_VHisc.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(MJ_VHisc.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function MJ_VHisc.spop(e,tp,eg,ep,ev,re,r,rp)
	if  Duel.IsExistingMatchingCard(MJ_VHisc.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,MJ_VHisc.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		local lv=sc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rc=Duel.SelectMatchingCard(tp,MJ_VHisc.refilter2,tp,LOCATION_ONFIELD,0,1,1,nil,lv):GetFirst()
		if sc and Duel.Release(rc,REASON_EFFECT) then 
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--MJW tograve
function MJ_VHisc.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp==1-tp and c:IsReason(REASON_DESTROY) and c:IsPreviousControler(tp))
end
function MJ_VHisc.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function MJ_VHisc.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT) then 
		local token=Duel.CreateToken(tp,33201009)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(8)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		token:RegisterEffect(e2,true)
		token:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201009,8))
	end
end