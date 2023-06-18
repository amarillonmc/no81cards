--乌托兰秘境 静谧河谷
if not pcall(function() require("expansions/script/c10100000") end) then require("script/c10100000") end
local s,id = Scl.SetID(10122001)
if not Scl_Utoland then
	Scl_Utoland = s

function Scl_Utoland.Link(c)
	c:EnableReviveLimit()
	local lk = c:GetLink()
	if lk == 1 then
		aux.AddLinkProcedure(c, aux.TRUE, 1, 1, s.link_group_filter)
	else
		aux.AddLinkProcedure(c, aux.TRUE, 1, lk, s.link_group_filter2)
	end
end
function s.link_group_filter(g, lc, tp)
	return g:IsExists(s.link_filter, 1, nil, tp)
end
function s.link_filter(c, tp)
	return s.link_filter2(c, tp) or (c:IsLinkSetCard(0xc333) and c:IsLinkAbove(2))
end
function s.link_group_filter2(g, lc, tp)
	return g:IsExists(s.link_filter2, 1, nil, tp)
end
function s.link_filter2(c, tp)
	return c:IsLinkCode(10122011) or (c:GetFlagEffect(10122019) > 0 and c:GetFlagEffectLabel(10122019) == tp)
end
function Scl_Utoland.GetTributeGroup(tp)
	local g1=Duel.GetReleaseGroup(tp):Filter(Card.IsSetCard, nil, 0xc333)
	local g2=Duel.GetMatchingGroup(s.tri_filter, tp, LOCATION_SZONE, 0, nil)
	return g1 + g2
end
function s.tri_filter(c)
	return c:IsSetCard(0xc333) and Scl.IsOriginalType(c,0,TYPE_MONSTER)
end
function Scl_Utoland.FieldActivateEffects(c, cid, cost, tg, minct, maxct, tk_exop)
	minct = minct or 1
	maxct = maxct or minct
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateQuickOptionalEffect({c, 0}, "FreeChain", "SpecialSummonToken", nil, "SpecialSummonToken", nil, nil, s.field_effect_con, cost, Scl_Utoland.Token_Target(minct, maxct, tg), s.field_effect_op(minct, maxct, tk_exop))
	local e3 = Scl.CloneEffect({c, 1}, e2)
	local e4 = Scl.CreateSingleBuffEffect(c, id, 1, "FieldZone")
	return e1,e2,e3,e4
end
function Scl_Utoland.FieldEffects(c, cid, cost, tg, minct, maxct, tk_exop)
	local e1, e2, e3, e4 = Scl_Utoland.FieldActivateEffects(c, cid, cost, tg, minct, maxct, tk_exop)
	local e5 = Scl.CreateQuickOptionalEffect(c, "ActivateEffect", "ActivateSpell", { 1, cid }, "ActivateSpell", nil, "FieldZone", nil, nil, { { "Target", "Return2Hand", Card.IsAbleToHand }, { "~Target", "ActivateSpell", s.hand_act_filter(cid), "Hand" } }, s.hand_act_op(cid))
	return e1,e2,e3,e4,e5
end
function s.field_effect_con(e)
	local c = e:GetOwner()
	local tp = e:GetHandlerPlayer()
	return c:IsHasEffect(id, tp) and c:IsControler(tp) and c:GetFlagEffect(id) == 0
end
function s.limit_act_count(e)
	local c = e:GetOwner()
	local tp = e:GetHandlerPlayer()
	local fc = Duel.GetFieldCard(tp, LOCATION_SZONE, 5)
	if fc and c == fc and c:GetFieldID() == fc:GetFieldID() then
		fc:RegisterFlagEffect(id, RESETS_EP_SCL, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 3))
	end
end
function Scl_Utoland.Token_Target(minct, maxct, tg, limit)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk == 0 then 
			if tg then 
				return tg(e,tp,eg,ep,ev,re,r,rp,0)
			else
				return Scl_Utoland.SpecialSummonTokenAble(tp, nil, minct, maxct)
			end
		end
		if not tg then
			Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,maxct,0,0)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,maxct,0,0)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
		if not limit then
			s.limit_act_count(e)
		end
	end
end
function Scl_Utoland.SpecialSummonTokenAble(tp, tc, minct, maxct)
	minct =minct or 1
	maxct = maxct or minct
	minct = type(minct) == "function" and minct(tp) or minct
	maxct = type(maxct) == "function" and maxct(tp) or maxct
	if minct == 0 then
		return false
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10122011,0xc333,0x4011,0,0,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		return false
	end
	if minct > 1 and Scl.IsAffectedByBlueEyesSpiritDragon(tp) then
		return false
	end
	if Scl.IsAffectedByBlueEyesSpiritDragon(tp) then
		maxct = 1
	end
	local useless_zone = 0
	local ct1, useless_zone1, ct2, useless_zone2 = 0,0,0,0x1f00
	ct1, useless_zone1 = Duel.GetMZoneCount(tp,tc)
	useless_zone1 = useless_zone1 - (useless_zone1 & 0x60)
	if Duel.IsPlayerAffectedByEffect(tp,10122012) then
		ct2, useless_zone2 = Scl.GetSZoneCount(tp,tc) 
		useless_zone2 = useless_zone2 * 0x100
	end
	useless_zone = useless_zone1 | useless_zone2
	local zct = ct1 + ct2
	return zct >= minct, useless_zone, minct, math.min(zct, maxct)
end
function s.field_effect_op(minct, maxct, tk_exop)
	return function(e, tp)
		local res = Scl_Utoland.SpecialSummonToken(e:GetOwner(), tp, minct, maxct)
		if tk_exop then
			tk_exop(e, tp, res)
		end
	end
end
function Scl_Utoland.SpecialSummonToken(c, tp, minct, maxct, buff)
	local bool, zone, minct2, maxct2 = Scl_Utoland.SpecialSummonTokenAble(tp, nil, minct, maxct)
	if not bool then return false end
	local res = false
	for i = 1, maxct2 do 
		local token = Duel.CreateToken(tp, 10122011) 
		Scl.HintSelect(tp, {id, 0})
		local sel_zone = Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,0,zone)
		if sel_zone & 0x1f ~= 0 then
			if Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP, sel_zone) then
				if buff then
					buff(c, token)
				end
				res = true
			end
		else
			sel_zone = sel_zone / 0x100
			Duel.MoveToField(token, tp, tp,LOCATION_SZONE, POS_FACEUP, true, sel_zone)
			if buff then
				buff(c, token)
			end
			local e1 = Scl.CreateSingleBuffCondition({c, token}, "=Type", TYPE_SPELL + TYPE_CONTINUOUS, "Spell&TrapZone", nil, RESETS_WITHOUT_SET_SCL)
			local e2 = Scl.CreateSingleBuffEffect(token, "ExtraLinkMaterial", s.ex_lmat_val, "Spell&TrapZone", nil, RESETS_SCL)
			local e3 = Scl.CreateFieldTriggerMandatoryEffect(token, "DuringEP", "NegateEffect", 1, "NegateEffect,Destroy", nil, "Spell&TrapZone", nil, nil, s.neg_tg, s.neg_op, RESETS_SCL)
		end
		if maxct2 ~= ct2 and i < maxct2 and i >= minct2 and not Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			break
		end
	end
	if res then
		Duel.SpecialSummonComplete()
	end
	return true
end
function s.xxmxattg(e,c)
	return c == e:GetHandler()
end
function s.ex_lmat_val(e,lc,mg,c,tp)
	if not (lc:IsSetCard(0xc333) and e:GetHandlerPlayer()==tp) then return false,nil end
	return true,true
end
function s.neg_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return true end
	local g = e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local g1 = g:Filter(aux.NegateAnyFilter,nil)
	local g2 = g:Filter(Card.IsFacedown,nil)
	if #g1 > 0 then
		Duel.SetOperationInfo(0, CATEGORY_NEGATE, g1, #g1, 0, 0)
	end
	if #g2 > 0 then
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, g2, #g2, 0, 0)
	end
end
function s.neg_op(e,tp,eg,ep,ev,re,r,rp)
	local g = e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local g1 = g:Filter(aux.NegateAnyFilter,nil)
	local g2 = g:Filter(Card.IsFacedown,nil)
	if #g1 > 0 then
		Scl.NegateCardEffects(g1)
	end
	if #g2 > 0 then
		Duel.Destroy(g2, REASON_EFFECT)
	end
end
function s.hand_act_filter(cid)
	return function(c,e,tp)
		return not c:IsCode(cid) and Scl.IsType(c, 0, TYPE_SPELL+TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
	end
end
function s.hand_act_op(cid)
	return function(e,tp)
		local c = Scl.GetActivateCard()
		if c and Duel.SendtoHand(c,nil,REASON_EFFECT) > 0 and c:IsLocation(LOCATION_HAND) then
			Scl.SelectAndOperateCards("ActivateSpell", tp, s.hand_act_filter(cid), tp, "Hand", 0, 1, 1, nil,e,tp)()
		end
	end
end
function Scl_Utoland.DeepFieldGYEffect(c, cid)
	return Scl.CreateQuickOptionalEffect(c, "ActivateEffect", "ActivateSpell", { 1, cid }, "ActivateSpell,Destroy", nil, "GY", nil, nil, { { "~Target", "Destroy", s.field_des_filter, "Spell&TrapZone" }, { "~Target", "ActivateSpell", s.gy_act_filter } }, s.gy_act_op)
end
function Scl_Utoland.DeepFieldEffects(c, cid, event, con, minct, maxct)
	minct = minct or 1
	maxct = maxct or minct
	local e1 = Scl.CreateActivateEffect(c)
	local e2 = Scl.CreateFieldTriggerOptionalEffect({c, 0}, event, "SpecialSummonToken", nil, "SpecialSummonToken", maxct == minct and "Delay" or nil, nil, s.deep_field_sp_con(con), nil, Scl_Utoland.Token_Target(minct, maxct, false, true), s.deep_field_effect_op(minct, maxct))
	local e3 = Scl.CloneEffect({c, 1}, e2)
	local e4 = Scl.CreateQuickOptionalEffect(c, "ActivateEffect", "ActivateSpell", { 1, cid }, "ActivateSpell,Destroy", nil, "GY", nil, nil, { { "~Target", "Destroy", s.field_des_filter, "Spell&TrapZone" }, { "~Target", "ActivateSpell", s.gy_act_filter } }, s.gy_act_op)
	local e5 = Scl.CreateSingleBuffEffect(c, id, 1, "FieldZone")
	return e1,e2,e3,e4,e5
end
function s.deep_field_sp_con(con)
	return function(e,tp,...)
		local c = e:GetOwner()
		return con(e,tp,...) and c:IsHasEffect(id) and c:IsControler(e:GetHandlerPlayer()) 
	end
end
function s.deep_field_effect_op(minct, maxct)
	return function(e, tp)
		if not Scl_Utoland.SpecialSummonToken(e:GetOwner(), tp, minct, maxct) then return end
		Scl_Utoland.LinkSummon(tp)
	end
end
function s.lnk_filter(c)
	return c:IsSetCard(0xc333) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end
function Scl_Utoland.LinkSummon(tp)
	local g=Duel.GetMatchingGroup(s.lnk_filter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,nil)
	end
end
function s.field_des_filter(c)
	return c:GetSequence() == 5
end
function s.gy_act_filter(c,e,tp)
	return c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.gy_act_op(e,tp)
	local c = Scl.GetActivateCard()
	local fc = Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if not fc or Duel.Destroy(fc,REASON_EFFECT) <= 0 or not c then return end
	Scl.ActivateCard(c, tp, tp, LOCATION_FZONE, POS_FACEUP, true)
end
function Scl_Utoland.Unaffected(c)
	local e1 = Scl.CreateSingleBuffEffect(c, "UnaffectedByOpponentsCardEffects", 1, "MonsterZone", Scl_Utoland.TokenCondition) 
	return e1
end
function Scl_Utoland.TokenCondition(e)
	return Duel.IsExistingMatchingCard(s.faceup_tkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.faceup_tkfilter(c)
	return c:IsFaceup() and c:IsCode(10122011)
end
--------------------------------------
end
--------------------------------------
if s then
-----------------------------------
function s.initial_effect(c)
	Scl_Utoland.FieldEffects(c, id, scl.cost_pay_lp(800))
end
------
end