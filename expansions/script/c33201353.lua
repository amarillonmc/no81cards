--六合精工 云纹青铜大铙
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
local m=33201353
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	VHisc_CNTdb.the(c,m,0x200+0x1000,0x10000)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	e1:SetOperation(cm.desrepop)
	c:RegisterEffect(e1)
end
cm.VHisc_CNTreasure=true

--e1
function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_LEAVE_FIELD_REDIRECT) and c:IsControler(tp) and VHisc_CNTdb.nck(c) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and not e:GetHandler():IsPublic() end
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=eg:Filter(cm.repfilter,nil,tp)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_PUBLIC)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
		local tg=e:GetLabelObject() 
		Duel.SendtoHand(tg,nil,REASON_EFFECT+REASON_REPLACE)
		if tg:GetFirst():IsLocation(LOCATION_HAND+LOCATION_EXTRA) then
			Duel.ConfirmCards(1-tp,tg)
			Duel.BreakEffect()
			--send to deck
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
			e1:SetType(EFFECT_TYPE_QUICK_O)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_HAND)
			e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
			e1:SetLabel(0)
			e1:SetTarget(cm.sthtg)
			e1:SetOperation(cm.sthop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function cm.spfilter(c,e,tp)
	return VHisc_CNTdb.nck(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsPublic() 
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.sthop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsPublic() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
end

--e0
function cm.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and VHisc_CNTdb.spck(e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and e:GetHandler():IsRelateToEffect(e) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=g:Select(tp,1,99,nil)
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
		end
	end
end