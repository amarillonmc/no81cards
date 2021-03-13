--瞬杀星 零式
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006010)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,cm.imcon)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.imcon(e)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local tc = c:GetBattleTarget()
	local atk1 = c:GetAttack()
	if chk == 0 then 
		if not tc or tc:IsControler(tp) or not tc:IsAttackAbove(atk1+1) then return false end
		local atk2 = tc:GetAttack()
		return Duel.IsPlayerCanDiscardDeck(tp,math.ceil((atk2 - atk1)/100))
	end 
end
function cm.tgop(e,tp)
	local c = e:GetHandler()
	local tc = c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() or not tc:IsRelateToBattle() or tc:IsFacedown() then return end
	local atk1,atk2 = c:GetAttack(),tc:GetAttack()
	if atk1 >= atk2 then return end
	local ct = math.ceil((atk2 - atk1)/100)
	if not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	local e1 = rscf.QuickBuff(c,"atk+",ct*100)
end
