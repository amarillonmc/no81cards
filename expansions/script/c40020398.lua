--瞬耀-Ξ高达[初阵]
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
s.named_with_XiGundam=1
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.Hathaway(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Hathaway
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	c:EnableCounterPermit(0x1f1e)
	
	aux.AddXyzProcedure(c, nil, 5, 4)
	c:EnableReviveLimit()

	local e0 = Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id, 0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1, id)
	e0:SetCondition(s.xyzcon_alt)
	e0:SetTarget(s.xyztg_alt)
	e0:SetOperation(s.xyzop_alt)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.poscon)
	e1:SetTarget(s.postg)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.dircon)
	c:RegisterEffect(e2)
end


function s.ovfilter(c, tp, xyzc)
	return s.XiGundam(c) and c:IsFaceup() and c:GetCounter(0x1f1e) >= 2
		and c:IsCanBeXyzMaterial(xyzc)
end

function s.xyzcon_alt(e, c)
	if c==nil then return true end
	local tp = c:GetControler()
	return Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
		and Duel.IsExistingMatchingCard(s.ovfilter, tp, LOCATION_MZONE, 0, 1, nil, tp, c)
end

function s.xyztg_alt(e, tp, eg, ep, ev, re, r, rp, chk, c)
	if chk == 0 then return true end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
	local g = Duel.SelectMatchingCard(tp, s.ovfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, tp, c)
	if g:GetCount() > 0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.xyzop_alt(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	if not g then return end
	local tc = g:GetFirst()
	if tc then
		local ct = tc:GetCounter(0x1f1e) 
		local mg = tc:GetOverlayGroup()
		if mg:GetCount() > 0 then
			Duel.Overlay(c, mg)
		end
		c:SetMaterial(g)
		Duel.Overlay(c, g)
		
		if ct > 0 then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetOperation(function(e, tp, eg)
				if eg:IsContains(c) then
					c:AddCounter(0x1f1e, ct)
					e:Reset() 
				end
			end)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, tp)
		end
	end
end

function s.poscon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.postg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.posfilter, tp, 0, LOCATION_ONFIELD, 1, nil) end
	local g = Duel.GetMatchingGroup(s.posfilter, tp, 0, LOCATION_ONFIELD, nil)
	Duel.SetOperationInfo(0, CATEGORY_POSITION, g, 1, 0, 0)
end

function s.posop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(s.posfilter, tp, 0, LOCATION_ONFIELD, nil)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local sg = g:Select(tp, 1, 4, nil)
		if sg:GetCount() > 0 then
			Duel.HintSelection(sg)
			local tc = sg:GetFirst()
			while tc do
				if tc:IsType(TYPE_MONSTER) then
					Duel.ChangePosition(tc, POS_FACEDOWN_DEFENSE)
				else
					Duel.ChangePosition(tc, POS_FACEDOWN)
				end
				tc = sg:GetNext()
			end
			
			if Duel.IsExistingMatchingCard(s.Hathaway, tp, LOCATION_ONFIELD, 0, 1, nil) then
				local act = Duel.GetMatchingGroupCount(Card.IsPosition, tp, 0, LOCATION_MZONE, nil, POS_ATTACK)
				if act > 0 and Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) > 0 then
					Duel.BreakEffect()
					Duel.DiscardHand(1-tp, nil, act, act, REASON_EFFECT + REASON_DISCARD, nil, REASON_RNG)
				end
			end
		end
	end
end

function s.dircon(e)
	local tp = e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFacedown, tp, 0, LOCATION_ONFIELD, 1, nil)
		and e:GetHandler():GetCounter(0x1f1e) >= 6
end