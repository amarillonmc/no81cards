--量子驱动 线程操作员
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,s.lfilter,1,1)
	c:EnableReviveLimit()
	local e1 = Scl.CreateIgnitionEffect(c, {id, 0}, {1, id}, "NormalSummon/Set", nil, "MonsterZone", nil, nil, s.tg, s.op)
	local e2 = Scl.CreateFieldBuffEffect(c, "MustAttack", 1, nil, {0, "MonsterZone"}, "MonsterZone", s.setcon)
	local e3 = Scl.CreatePlayerBuffEffect(c, "YouChooseAttackTargets4OpponentsAttacks", 1, nil, {0, 1}, "MonsterZone", s.setcon)
	Scl_Quantadrive.CreateNerveContact(s, e1)
end
function s.lfilter(c)
	return c:IsLinkRace(RACE_MACHINE) and c:IsSetCard(0xa336)
end
function s.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	local fe = c.Scl_Quantadrive_Filp_Effect
	if not fe then return false end
	local tg = fe:GetTarget() or aux.TRUE
	return not c:IsPublic() and c:IsSetCard(0xa336) and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then 
		Scl.Mandatory_Effect_Target_Check = true
		local res = e:IsCostChecked() and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
		Scl.Mandatory_Effect_Target_Check = false
		return res
	end
	Scl.Mandatory_Effect_Target_Check = true
	local ct, og, tc = Scl.SelectAndOperateCards("Reveal", tp, s.cfilter, tp, LOCATION_HAND, 0, 1, 1, nil,e,tp,eg,ep,ev,re,r,rp)()
	Scl.Mandatory_Effect_Target_Check = false
	local fe = tc.Scl_Quantadrive_Filp_Effect
	Duel.SetTargetCard(tc)
	Duel.ClearOperationInfo(0)
	e:SetProperty(fe:GetProperty())
	local tg = fe:GetTarget()
	if tg then 
		tg(e,tp,eg,ep,ev,re,r,rp,1) 
	end
end
function s.op(e,tp)
	local tc = Duel.GetFirstTarget()
	local fe = tc.Scl_Quantadrive_Filp_Effect
	local op = fe:GetOperation()
	Scl_Quantadrive.NerveContact_Forbbiden2 = true
	op(e,tp)
	Scl_Quantadrive.NerveContact_Forbbiden2 = false
	if tc:IsRelateToEffect(e) and (tc:IsSummonable(true, nil) or tc:IsMSetable(true, nil)) and Scl.SelectYesNo(tp, "NormalSummon/Set") then
		Duel.BreakEffect()
		Scl_Quantadrive.Summon = Scl_Quantadrive.Summon + 1
		Scl_Quantadrive.Summon_Limit[Scl_Quantadrive.Summon] = tc
		--Scl.NormalSummon(tc, tp, true, nil)
	end
end
function s.setcon(e,tp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil)
end