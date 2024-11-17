--[[川越探员→绝体绝命810！
Kawagoe, Scout of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--(Quick Effect): You can discard this card; the next time each player would take damage, they do not.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:HOPT()
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(aux.DiscardSelfCost)
	e1:SetOperation(s.nodamop)
	c:RegisterEffect(e1)
	--[[If this card is sent to the GY: Activate this effect; during the next End Phase, you can target a number of "BranD-810!" monsters in your GY,
	up to the number of "BranD-810!" cards that were destroyed by your opponent this turn up to the point this effect resolves,
	and shuffle them into your Deck, and if you do, gain LP equal to the total Level of the shuffled monsters x 500]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK|CATEGORY_GRAVE_ACTION|CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:HOPT()
	e2:SetTarget(s.applytg)
	e2:SetOperation(s.applyop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local PFLAG_COUNT_DESTROYED_CARDS = id

function s.regcfilter(c,p)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsReasonPlayer(p)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local ct=eg:FilterCount(s.regcfilter,nil,p)
		if ct>0 then
			if not Duel.PlayerHasFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS) then
				Duel.RegisterFlagEffect(p,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
			end
			Duel.UpdateFlagEffectLabel(p,PFLAG_COUNT_DESTROYED_CARDS,ct)
		end
	end
end

--E1
function s.nodamop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.refcon)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.refcon)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetTargetRange(0,1)
	Duel.RegisterEffect(e4,tp)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e4)
end
function s.refcon(e,re,val,r,rp,rc)
	if val>0 then
		e:GetLabelObject():Reset()
		e:Reset()
		return 0
	end
	return val
end

--E2
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.PlayerHasFlagEffect(1-tp,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(1-tp,PFLAG_COUNT_DESTROYED_CARDS) or 0
	if ct<=0 then return end
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(PHASE_END)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:OPT()
	e1:SetLabel(ct,rct,Duel.GetTurnCount())
	e1:SetCondition(s.endcon)
	e1:SetOperation(s.endop)
	e1:SetReset(RESET_PHASE|PHASE_END,rct)
	Duel.RegisterEffect(e1,tp)
end
function s.endcon(e,tp,eg,ep,ev,re,r,rp)
	local _,rct,tct=e:GetLabel()
	return rct==1 or Duel.GetTurnCount()>tct
end
function s.filter(c,e)
	return c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function s.lvfilter(c)
	return c:IsLocation(LOCATION_DECK) and c:IsMonster() and c:HasLevel()
end
function s.endop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(aux.Necro(s.filter),tp,LOCATION_GRAVE,0,nil,e)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,tp,id)
	local ct=e:GetLabel()
	Duel.HintMessage(tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,ct,nil)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.SetTargetCard(tg)
		if Duel.ShuffleIntoDeck(tg)>0 then
			local lvg=Duel.GetOperatedGroup():Filter(s.lvfilter,nil)
			if #lvg==0 then return end
			local lv=lvg:GetSum(Card.GetLevel)
			if lv>0 then
				Duel.Recover(tp,lv*500,REASON_EFFECT)
			end
		end
	end
end