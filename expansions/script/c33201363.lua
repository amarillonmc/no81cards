--六合精工 天蓝釉刻花鹅颈瓶
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
local m=33201363
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c33201350") end,function() require("script/c33201350") end)
function cm.initial_effect(c)
	VHisc_CNTdb.the(c,m,0x200,0x10000)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sthtg)
	e1:SetOperation(cm.sthop)
	c:RegisterEffect(e1)
	--creat table
	VHisc_CNTdb.creattable()
end
cm.VHisc_CNTreasure=true

--e1
function cm.thfilter(c)
	return VHisc_CNTdb.nck(c)
end
function cm.sthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=1 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=1 end
end
function cm.sthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=1 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:SelectSubGroup(tp,aux.dncheck,false,1,1)
		Duel.ConfirmCards(1-tp,sg1)
		local sc=sg1:GetFirst()
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
		c:RegisterEffect(e1,true)
		--tohand
		local e0=Effect.CreateEffect(c)
		e0:SetCategory(CATEGORY_TOHAND)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetRange(LOCATION_SZONE)
		e0:SetLabel(sc:GetCode())
		e0:SetCountLimit(1)
		e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
		e0:SetCondition(cm.rthcon)
		e0:SetTarget(cm.rthtg)
		e0:SetOperation(cm.rthop)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e0)
		c:SetHint(CHINT_CARD,sc:GetCode())
	end
end

function cm.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local code=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,code) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.rthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,cg) then
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,cg)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then 
				Duel.BreakEffect()
				Duel.SendtoHand(c,tp,REASON_EFFECT)
			end
		end
	end
end

--e0
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return VHisc_CNTdb.spck(e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local tc=sg:GetFirst()
	----------------code table add code----------------------
			if not VHisc_CNTdb.codeck(VHisc_CNTN,tc) then
				VHisc_CNTN[#VHisc_CNTN+1]=tc:GetOriginalCode()
			end
		end
	end
end