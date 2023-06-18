--来自乌托兰秘境的守护者
local s,id = GetID()
if not pcall(function() require("expansions/script/c10122001") end) then require("script/c10122001") end
function s.initial_effect(c)
	Scl_Utoland.Link(c)
	local e1 = Scl_Utoland.Unaffected(c)
	--local e2 = Scl.CreateFieldBuffEffect(c, "!BeBattleTarget", 1, s.tg, {"MonsterZone", 0}, "MonsterZone", Scl_Utoland.TokenCondition)
	local e2 = Scl.CreateFieldBuffEffect(c, "!BeDestroyedByBattle", 1, s.tg, {"MonsterZone", 0}, "MonsterZone", Scl_Utoland.TokenCondition)
	local e3 = Scl.CreatePlayerBuffEffect(c, "GainLPInsteadOfTakingDamage", s.val, nil, {1, 0}, "MonsterZone", Scl_Utoland.TokenCondition)
	local e4 = Scl.CreateEffectBuffEffect(c, "!NegateActivation", s.efilter, "MonsterZone", Scl_Utoland.TokenCondition)
	local e5 = Scl.CreateEffectBuffEffect(c, "!NegateActivatedEffect", s.efilter, "MonsterZone", Scl_Utoland.TokenCondition)
end
function s.tg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc333)
end
function s.efilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsSetCard(0xc333)
end
function s.val(e,re,r,rp,rc)
	if r & REASON_BATTLE ==0 then 
		return false
	end
	local tp=e:GetHandlerPlayer()
	local bc=rc:GetBattleTarget()
	return bc and bc:IsSetCard(0xc333) and bc:IsControler(tp)
end
