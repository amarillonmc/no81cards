--猎兽魔女：狩猎
local m=91300031
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c91300031.cost)
	e1:SetTarget(c91300031.target)
	e1:SetOperation(c91300031.activate)
	c:RegisterEffect(e1)
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c91300031.thcost)
	e2:SetTarget(c91300031.thtg)
	e2:SetOperation(c91300031.thop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	
end
c91300031.hackclad=2
function c91300031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:GetHandler():CancelToGrave()
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c91300031.filter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c91300031.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	return c.hackclad==1 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and g:GetClassCount(Card.GetCode)>=3
end
function c91300031.filter2(c,e,tp,xc)
	return c.hackclad==1 and c:IsAbleToRemove() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,xc,c)>0
end
function c91300031.filter3(c)
	return c.hackclad==1 and c:IsAbleToRemove()
end
function c91300031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c91300031.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c91300031.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c91300031.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c91300031.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c91300031.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local oc=sg:RandomSelect(1-tp,1):GetFirst()
		if Duel.Remove(oc,POS_FACEUP,REASON_EFFECT) and oc:IsLocation(LOCATION_REMOVED) then
			sg:RemoveCard(oc)
			if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
			if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if sc then
				local mg=tc:GetOverlayGroup()
				if mg:GetCount()~=0 then
					Duel.Overlay(sc,mg)
				end
				sc:SetMaterial(Group.FromCards(tc))
				Duel.Overlay(sc,Group.FromCards(tc))
				if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
					sc:CompleteProcedure()
					if c:IsRelateToEffect(e) then
						c:CancelToGrave()
						Duel.Overlay(sc,Group.FromCards(c))
					end
					sg:RemoveCard(sc)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetProperty(EFFECT_FLAG_DELAY)
					e1:SetCode(EVENT_SPSUMMON_SUCCESS)
					e1:SetLabelObject(sg:GetFirst())
					e1:SetCondition(c91300031.xyzcon)
					e1:SetOperation(c91300031.xyzop)
					Duel.RegisterEffect(e1,tp)
					sg:GetFirst():RegisterFlagEffect(91300031,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(91300031,3))
				end
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c91300031.cttg)
	e2:SetOperation(c91300031.ctop)
	Duel.RegisterEffect(e2,1-tp)
end
function c91300031.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c.hackclad==1
end
function c91300031.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and  eg:IsExists(c91300031.cfilter,1,nil,tp)
end
function c91300031.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ttc=e:GetLabelObject()
	if tc and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and not tc:IsImmuneToEffect(e) and ttc:GetFlagEffect(91300031)~=0 and tc:IsFaceup() and ttc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,ttc)>0 then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(ttc,mg)
		end
		ttc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(ttc,Group.FromCards(tc))
		Duel.SpecialSummon(ttc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		ttc:CompleteProcedure()
	end
	e:Reset()
end

function c91300031.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c91300031.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsCanRemoveCounter(tp,1,1,0x1614,3,REASON_COST) and Duel.IsExistingMatchingCard(c91300031.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.IsCanRemoveCounter(tp,1,1,0x1614,4,REASON_COST) and Duel.IsPlayerCanDraw(tp,1)
	local b3=Duel.IsCanRemoveCounter(tp,1,1,0x1614,6,REASON_COST) and Duel.IsExistingMatchingCard(aux.TURE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(91300031,4)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(91300031,5)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(91300031,6)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.RemoveCounter(tp,1,1,0x1614,3,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.RemoveCounter(tp,1,1,0x1614,4,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.RemoveCounter(tp,1,1,0x1614,6,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c91300031.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c91300031.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	elseif e:GetLabel()==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif e:GetLabel()==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,3,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c91300031.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c91300031.thfilter(c)
	return c.hackclad==2 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c91300031.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c91300031.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c91300031.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c91300031.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c91300031.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
