--[[绝体绝命810！←欣慰的薄荷泪水！
BranD-810! Mint Tears of Relief!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--[[During the Xth End Phase after a "BranD-810!" monster(s) is sent to the GY (X is 3 minus the number of "BranD-810!" that were cards destroyed
	this turn. If X is 0 or less, this effect applies during the End Phase of this turn): Gain LP equal to the total DEF of those sent monsters,
	and if you do, for each 1000 LP you gain this way, you can add 1 "BranD-810!" card from your Deck or GY to your hand (if 2 or more cards would be
	added by this effect, they must have different names.)]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetLabelObject(aux.AddThisCardInFZoneAlreadyCheck(c))
	e1:SetFunctions(
		aux.AlreadyInRangeEventCondition(s.regconfilter),
		nil,
		nil,
		s.regeffop
	)
	c:RegisterEffect(e1)
	--[[If this card is sent from the field to the GY: You can Set a "BranD-810!" Field Spell, except "BranD-810! Mint Tears of Relief!" from your Deck
	in your Field Zone, but it cannot be activated this turn.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetFunctions(s.setcon,nil,s.settg,s.setop)
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

local FLAG_REGISTERED_EP_EFFECT = id
local PFLAG_COUNT_DESTROYED_CARDS = id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsSetCard,nil,ARCHE_BRAND_810)
	if ct>0 then
		if not Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) then
			Duel.RegisterFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
		end
		Duel.UpdateFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS,ct)
	end
end

--E1
function s.regconfilter(c,e,tp)
	return c:IsMonster() and c:IsSetCard(ARCHE_BRAND_810)
end
function s.regeffop(e,tp,eg,ep,ev,re,r,rp)
	local val=eg:GetSum(Card.GetDefense)
	local tct=Duel.GetTurnCount()
	local c=e:GetHandler()
	local ct=Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS) or 0
	ct=ct+eg:FilterCount(Card.IsReason,nil,REASON_DESTROY)
	local x=math.max(1,3-ct)
	local fe=c:GetFlagEffectWithSpecificLabel(FLAG_REGISTERED_EP_EFFECT,tct+x-1)
	if not fe then
		fe=Effect.CreateEffect(c)
		fe:SetType(EFFECT_TYPE_SINGLE)
		fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		fe:SetCode(EFFECT_FLAG_EFFECT|FLAG_REGISTERED_EP_EFFECT)
		fe:SetLabel(tct+x-1,val)
		fe:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,x)
		c:RegisterEffect(fe,true)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetCategory(CATEGORY_RECOVER|CATEGORIES_SEARCH|CATEGORY_GRAVE_ACTION)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE|PHASE_END)
		e1:SetRange(LOCATION_FZONE)
		e1:SetLabel(tct+x-1)
		e1:SetCountLimit(999)
		e1:SetFunctions(s.rccon,nil,s.rctg,s.rcop)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,x)
		c:RegisterEffect(e1,true)
	else
		fe:SetSpecificLabel(val,0)
	end
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local turnct=e:GetLabel()
	if Duel.GetTurnCount()~=turnct then return false end
	local fe=c:GetFlagEffectWithSpecificLabel(FLAG_REGISTERED_EP_EFFECT,turnct)
	local labels={fe:GetLabel()}
	if #labels<2 then
		e:Reset()
		return false
	end
	return true
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local turnct=e:GetLabel()
	local fe=c:GetFlagEffectWithSpecificLabel(FLAG_REGISTERED_EP_EFFECT,turnct)
	local labels={fe:GetLabel()}
	local vals={fe:GetLabel()}
	table.remove(vals,1)
	local val
	if #vals==1 then
		val=vals[1]
	else
		Duel.HintMessage(tp,aux.Stringid(id,1))
		val=Duel.AnnounceNumber(tp,table.unpack(vals))
	end
	for i,label in ipairs(labels) do
		if label==val then
			table.remove(labels,i)
			break
		end
	end
	fe:SetLabel(table.unpack(labels))
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetTargetParam()
	local ct=math.floor(Duel.Recover(tp,val,REASON_EFFECT)/1000)
	local g=Duel.Group(aux.Necro(s.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,nil)
	if ct>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local tg=aux.SelectUnselectGroup(g,e,tp,1,ct,aux.dncheckbrk,1,tp,HINTMSG_ATOHAND)
		if #tg>0 then
			Duel.Search(tg)
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsAbleToHand()
end

--E2
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsSpell(TYPE_FIELD) and c:IsSetCard(ARCHE_BRAND_810) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc,tp,false)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		sc:RegisterEffect(e1)
	end
end