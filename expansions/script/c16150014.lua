--真言之天命 真剑之王命
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16150014,"TENMEIOUMEI")
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_EQUIP)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetOperation(cm.aop)
	c:RegisterEffect(e3)
end
function cm.cost(e)
	e:SetLabel(1)
	return true
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.thfilter(c,tp)
	return c:IsReleasable() and Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function cm.thfilter1(c,rc)
	local tpe=rc:GetType()&0x7
	return (rk.check(c,"OUMEI") or rk.check(c,"DAIOU")) and c:IsAbleToHand() and c:IsType(tpe)
end
function cm.tpfilter(c)
	local tpe=c:GetOriginalType()&0x7
	return tpe
end
function cm.addfilter(g)
	return g:GetClassCount(cm.tpfilter,TYPE_SPELL)==#g
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=eg:IsExists(cm.spfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
	local b=eg:IsExists(cm.thfilter,1,nil,tp)
	local c=eg:IsExists(Card.IsAbleToHandAsCost,1,nil)
	if chk==0 then
		if e:GetLabel()==1 then
			return a or b or c 
		else
			return false
		end
	end
	local op=2
	if a and b and c then
			op=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6),aux.Stringid(m,7))
	elseif a and b then
			op=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,6))
	elseif b and c then
			op=Duel.SelectOption(tp,aux.Stringid(m,6),aux.Stringid(m,7))+1
	elseif a and c then
		op=Duel.SelectOption(tp,aux.Stringid(m,5),aux.Stringid(m,7))
		if op==1 then
			op=op+1
		end 
	elseif a then
		op=Duel.SelectOption(tp,aux.Stringid(m,5))
	elseif b then
		op=Duel.SelectOption(tp,aux.Stringid(m,6))+1
	elseif c then
		op=Duel.SelectOption(tp,aux.Stringid(m,7))+2
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,eg,1,tp,0)
		e:SetLabel(4)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=eg:Filter(cm.thfilter,nil,tp)
		local sg=g:SelectSubGroup(tp,cm.addfilter,false,1,#g)
		Duel.Release(sg,REASON_COST)
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		e:SetLabelObject(og)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#sg,tp,LOCATION_DECK)
		e:SetLabel(5)
   elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local rg=eg:FilterSelect(tp,Card.IsAbleToHandAsCost,1,#eg,nil)
		local og=Group.CreateGroup()
		for tc in aux.Next(rg) do
			local eqc=tc:GetEquipTarget()
			if eqc then
				og:AddCard(eqc)
			end
		end
		og:KeepAlive()
		e:SetLabelObject(og)
		Duel.SendtoHand(rg,tp,REASON_COST)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
			e:SetLabel(7)
		else
			e:SetLabel(6)
		end
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
   end
end
function cm.tpefilter(c,tpe)
	return c:GetOriginalType()&tpe~=0
end
function cm.adfilter1(c,tpe,og)
	return c:IsAbleToHand() and (rk.check(c,"OUMEI") or rk.check(c,"DAIOU")) and not c:IsType(tpe) and og:IsExists(cm.tpefilter,1,nil,c:GetType()&0x7)
end
function cm.imfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function cm.val(e,re)
	return re:GetHandlerPlayer()~=e:GetOwnerPlayer()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return false end
	if e:GetLabel()==4 and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=eg:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif e:GetLabel()==5 then
		local og=e:GetLabelObject()
		local tpe=0x0
		local ag=Group.CreateGroup()
		for i=0,#og do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,cm.adfilter1,tp,LOCATION_DECK,0,1,1,nil,tpe,og)
			if sg:GetCount()>0 then
				local tc=sg:GetFirst()
				tpe=tpe|(tc:GetType()&0x7)
				ag:Merge(sg)
			end
		end
		if ag:GetCount()>0 then
			Duel.SendtoHand(ag,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ag)
		end
	elseif e:GetLabel()==6 then
		local og=e:GetLabelObject()
		local ig=og:Filter(cm.imfilter,nil)
		if ig:GetCount()>0 then
			for tc in aux.Next(ig) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetValue(cm.val)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				e1:SetOwnerPlayer(tp)
				tc:RegisterEffect(e1)
			end
		end
	elseif e:GetLabel()==7 then
		local og=e:GetLabelObject()
		local ig=og:Filter(cm.imfilter,nil)
		if ig:GetCount()>0 then
			for tc in aux.Next(ig) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetValue(cm.val)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
				e1:SetOwnerPlayer(tp)
				tc:RegisterEffect(e1)
			end
		end
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsSummonable,tp,LOCATION_HAND,0,1,nil,true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sc=Duel.SelectMatchingCard(tp,Card.IsSummonable,tp,LOCATION_HAND,0,1,1,nil,true,nil):GetFirst()
			if sc then
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end
function cm.aop(e,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(cm.rtg)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetOwnerPlayer(tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(cm.advtg)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function cm.rtg(e,rc)
	return rc:IsLocation(LOCATION_SZONE) or ( rc:IsFaceup() and rc:IsType(TYPE_SPELL+TYPE_TRAP) ) 
end
function cm.advtg(e,c)
	return c:IsLevelAbove(5)
end