--[[
动物朋友导游 未来
Mirai, Anifriends' Park Guide
Card Author: nemoma
Scripted by: XGlitchy30
]]
local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,nil,s.lcheck)
	c:EnableReviveLimit()
	--Gains 1000 ATK for each "Anifriends" monster this card points to.
	c:UpdateATK(s.atkval)
	--This card gains the following effects, based on its ATK:
	----0: Shuffle this card into the Extra Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetFunctions(s.atkcon(0),nil,nil,s.tdop)
	c:RegisterEffect(e1)
	----1000+: This card is unaffected by your opponent's card effects, also it cannot be destroyed by battle.
	c:Unaffected(UNAFFECTED_OPPO,s.atkcon(1000))
	c:CannotBeDestroyedByBattle(1,s.atkcon(1000))
	----2000+: Once per turn: You can gain LP equal to the total DEF of all "Anifriends" monsters this card points to.
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:OPT()
	e2:SetFunctions(s.atkcon(2000),nil,s.lptg,s.lpop)
	c:RegisterEffect(e2)
	----3000+: All cards this card points to are unaffected by your opponent's card effects and cannot be destroyed by battle, also you take no damage.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetCondition(s.atkcon(3000))
	e3:SetTarget(s.imtg)
	e3:SetValue(aux.imoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetCondition(s.atkcon(3000))
	e5:SetValue(0)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e6)
end

function s.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,ARCHE_ANIFRIENDS) and g:GetClassCount(Card.GetLinkCode)==#g
end

--atk
function s.atkval(e,c)
	local h=e:GetHandler()
	local g=h:GetLinkedGroup()
	if not g then return 0 end
	return g:FilterCount(aux.FaceupFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),nil)*1000
end

--E1
function s.atkcon(atk)
	if atk==0 then
		return	function(e)
					return e:GetHandler():IsAttack(0)
				end
	else
		return	function(e)
					return e:GetHandler():IsAttackAbove(atk)
				end
	end
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttack(0) then
		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end

--E2
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetLinkedGroup()
	if chk==0 then
		return g and g:Filter(aux.FaceupFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),nil):GetSum(Card.GetDefense)>0
	end
	local val=g:Filter(aux.FaceupFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),nil):GetSum(Card.GetDefense)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local p=Duel.GetTargetPlayer()
	local val=g:Filter(aux.FaceupFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),nil):GetSum(Card.GetDefense)
	Duel.Recover(p,val,REASON_EFFECT)
end

--E3
function s.imtg(e,c)
	local g=e:GetHandler():GetGlitchyLinkedGroup()
	return g and g:IsContains(c)
end