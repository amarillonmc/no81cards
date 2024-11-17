--[[水色桑葚↗绝体绝命810！
BranD-810!'s Pastel Mulberry
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--You can only control 1 face-up "BranD-810!'s Pastel Mulberry".
	c:SetUniqueOnField(1,0,id)
	--[[During the End Phase, if a "BranD-810!" monster(s) was destroyed by your opponent and sent to the GY this turn:
	You can Special Summon this card from your Extra Deck, and if you do, attach that monster(s) from your GY to this card as material]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_EXTRA)
	e1:OPT()
	e1:SetFunctions(nil,nil,s.sptg,s.spop)
	c:RegisterEffect(e1)
	--[[If another "BranD-810!" monster would be destroyed by your opponent, you can attach it to this card as material instead.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
	--This card's ATK becomes equal to the total ATK of all "BranD-810!" monsters attached to it
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.adval)
	c:RegisterEffect(e3)
	--This card can attack your opponent directly
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
	--[[If this card attacks your opponent directly: Activate this effect; if your opponent would take battle damage from this battle,
	they do not, but they must send a number of cards from the top of their Deck to the GY equal to the number of material attached to this card.]]
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetFunctions(s.tgcon,nil,s.tgtg,s.tgop)
	c:RegisterEffect(e5)
end
--E1
function s.atfilter(c,e,tp,xyzc,tid)
	return c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810) and c:IsReason(REASON_DESTROY) and c:GetReasonPlayer()==1-tp and c:GetTurnID()==tid and c:IsCanBeAttachedTo(xyzc,e,tp,REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExists(false,s.atfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c,Duel.GetTurnCount())
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.Group(s.atfilter,tp,LOCATION_GRAVE,0,nil,e,tp,c,Duel.GetTurnCount())
		if #g>0 then
			Duel.Attach(g,c,false,e,REASON_EFFECT,tp)
		end
	end
end

--E2
function s.repfilter(c,e,tp,xyzc)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsSetCard(ARCHE_BRAND_810) and (c:IsMonster() or c:IsLocation(LOCATION_MZONE))
		and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_REPLACE) and c:IsCanBeAttachedTo(xyzc,e,tp,REASON_EFFECT|REASON_REPLACE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,c,e,tp,c) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(s.repfilter,c,e,tp,c)
		if #g>0 then
			Duel.Attach(g,c,false,e,REASON_EFFECT|REASON_REPLACE,tp)
		end
		return true
	end
	return false
end
function s.repval(e,c)
	return s.repfilter(c,e,e:GetHandlerPlayer(),e:GetHandler())
end

--E3
function s.adfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810)
end
function s.adval(e,c)
	local h=e:GetHandler()
	if not h:IsType(TYPE_XYZ) then return 0 end
	local g=h:GetOverlayGroup():Filter(s.adfilter,nil)
	return g:GetSum(Card.GetAttack)
end

--E5
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetOperation(s.damop)
	e2:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE)
    c:RegisterEffect(e2,true)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsType(TYPE_XYZ) then return end
	local ct=c:GetOverlayCount()
    if ep==1-tp and ev>0 and ct>0 and Duel.IsPlayerCanDiscardDeck(1-tp,ct) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.ChangeBattleDamage(1-tp,0)
		Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
    end
end