--[[
记忆抹刀
Memory Shaver
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	--[[If the equipped monster would inflict battle damage to your opponent, your opponent takes no battle damage from that battle, then your opponent sends 1 card from the top of their Deck
	to their GY for each 400 damage they would have taken (rounded up)]]
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(aux.IsEquippedCond)
    e1:SetOperation(s.damop)
    c:RegisterEffect(e1)
	--[[If this card is sent to the GY because the equipped monster is destroyed by battle, the previous controller of that monster can place the top 10 cards of their Deck on the top of their
	opponent's Deck (in any order), and if they do, they can equip this card to 1 face-up monster on the field.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.eqcon)
	e3:SetTarget(aux.RelationTarget)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
end
--E1
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
    if ep==1-tp and rc==c:GetEquipTarget() then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.ChangeBattleDamage(1-tp,0)
		Duel.DiscardDeck(1-tp,math.ceil(ev/400),REASON_EFFECT)
    end
end

--E2
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:GetReason()&(REASON_DESTROY|REASON_BATTLE)==REASON_DESTROY|REASON_BATTLE
end
function s.eqfilter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local p=ec:GetPreviousControler()
	if Duel.GetDeckCount(p)>=10 and Duel.SelectEffectYesNo(p,c) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.GetDecktopGroup(p,10)
		Duel.DisableShuffleCheck()
		if Duel.SendtoDeck(g,1-p,SEQ_DECKTOP,REASON_EFFECT,p)>0 then
			local ct=Duel.GetGroupOperatedByThisEffect(e):FilterCount(aux.PLChk,nil,1-p,LOCATION_DECK)
			Debug.Message(ct)
			Duel.SortDecktop(p,1-p,ct)
			if c:IsRelateToEffect(e) and Duel.GetLocationCount(p,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(p)
				and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
				local eqg=Duel.Select(HINTMSG_EQUIP,false,p,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c)
				Duel.HintSelection(eqg)
				Duel.Equip(p,c,eqg:GetFirst())
			end
		end
	end
end