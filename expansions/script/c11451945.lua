--方程式运动员 尾流超越车手
local cm,m=GetID()
function cm.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.lvcon)
	e3:SetOperation(cm.lvop)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_HAND+LOCATION_DECK)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(m)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_HAND+LOCATION_DECK)
	e7:SetCode(EVENT_ADJUST)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(cm.adop)
	c:RegisterEffect(e7)
end
function cm.atkval(e,c)
	return c:GetLevel()*300
end
function cm.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0x107)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_LEVEL)
		e4:SetValue(1)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e4)
		if c:GetLevel()~=lv and c:IsLevelAbove(7) then
			local e5=e4:Clone()
			e5:SetValue(-3)
			c:RegisterEffect(e5)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then Duel.SSet(tp,tc) end
		end
	end
end
function cm.filter(c)
	return c:IsSetCard(0x107) and c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and c:IsSSetable()
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(0,1,1)+Duel.GetFieldGroup(0,0xff,0xff)
	g=g:Filter(function(c) return c:IsSetCard(0x107) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetFlagEffect(m)==0 end,nil)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,0,0,1)
		local te=tc:GetActivateEffect()
		if te and (not te:GetDescription() or te:GetDescription()==0) then
			te:SetDescription(aux.Stringid(m,0))
			local e5=Effect.CreateEffect(tc)
			e5:SetDescription(aux.Stringid(m,1))
			e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
			e5:SetType(EFFECT_TYPE_ACTIVATE)
			e5:SetCode(EVENT_FREE_CHAIN)
			e5:SetTarget(cm.sptg)
			e5:SetOperation(cm.spop)
			tc:RegisterEffect(e5,true)
		end
	end
end
function cm.eftg(e,c)
	return c:IsSetCard(0x107) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.dfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function cm.spfilter(c,e,tp)
	return c:IsHasEffect(m) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsPublic() or not c:IsLocation(LOCATION_HAND))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.dfilter,tp,LOCATION_ONFIELD,0,c,tp)
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local sg1=sg:Filter(function(c) return c:GetFlagEffect(m+1)==0 end,nil)
	local sg2
	if #sg1==#sg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg2=sg:Select(tp,1,1,nil)
	elseif #sg1>0 and #sg1<#sg then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
		sg2=sg1:CancelableSelect(tp,1,1,nil)
	end
	if not sg2 or #sg2==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg2=sg:Select(tp,1,1,nil)
	end
	Duel.ConfirmCards(tp,sg2)
	Duel.ConfirmCards(1-tp,sg2)
	sg2:GetFirst():RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
	if sg2:GetFirst():IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	Duel.SetTargetCard(sg2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg2,1,tp,sg2:GetFirst():GetLocation())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.dfilter,tp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),tp)
	if #g==0 then g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e),tp) end
	Duel.HintSelection(g)
	if Duel.Destroy(g,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #tg>0 and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)>0 then
			local eset={e:GetHandler():GetActivateEffect()}
			local tab,tab2={},{}
			for i,te in pairs(eset) do
				if te~=e then
					local tg=te:GetTarget()
					local op=te:GetOperation()
					if (not tg or (tg and tg(te,tp,eg,ep,ev,re,r,rp,0))) and op then
						tab[#tab+1]=te:GetDescription()
						tab2[#tab]=i
					end
				end
			end
			if #tab==0 then return end
			tab[#tab+1]=aux.Stringid(m,3)
			tab2[#tab]=0
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local opt=tab2[1+Duel.SelectOption(tp,table.unpack(tab))]
			if opt==0 then return end
			local te=eset[opt]
			local target=te:GetTarget()
			local operation=te:GetOperation()
			Duel.ClearTargetCard()
			if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				Duel.HintSelection(g)
				for fc in aux.Next(g) do
					fc:CreateEffectRelation(te)
				end
			end
			if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
			if g then
				for fc in aux.Next(g) do
					fc:ReleaseEffectRelation(te)
				end
			end
		end
	end
end