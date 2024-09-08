--[[
万念归一之境界
Realm Where Everything Gathers
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:Activation()
	--[[If an Equip Card(s) that was equipped to a Token you controlled is sent to the GY from your Spell & Trap Zone: You can add it to your hand.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_TO_GRAVE,s.cfilter,id,LOCATION_SZONE,nil,LOCATION_SZONE,nil,id+100)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_SZONE)
	e1:HOPT()
	e1:SetFunctions(nil,nil,s.thtg,s.thop)
	c:RegisterEffect(e1)
	--[[During your Main Phase: You can take 1 "Realm Where Everything Gathers" from your Deck or GY, and place it face-up in your Spell & Trap Zone.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SHOPT()
	e2:SetFunctions(nil,nil,s.pctg,s.pcop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD_P)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		local g=ec:GetEquipGroup()
		local eqc=ec:GetEquipTarget()
		if eqc~=nil and eqc:IsFaceup() and eqc:IsType(TYPE_TOKEN) then
			ec:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD_EXC_GRAVE,0,0,eqc:GetControler())
		elseif g and #g>0 and ec:IsFaceup() and ec:IsType(TYPE_TOKEN)  then
			for tc in aux.Next(g) do
				tc:RegisterFlagEffect(id+200,RESET_EVENT|RESETS_STANDARD_EXC_GRAVE,0,0,ec:GetControler())
			end
		end
	end
end
--E1
function s.cfilter(c,_,tp)
	if not (c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP~=0) then return false end
	return c:HasFlagEffectLabel(id+200,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsAbleToHand,nil)
	if chk==0 then
		return #g>0
	end
	local opinfochk=false
	local sg=aux.SelectSimultaneousEventGroup(g,tp,id+100,1,e)
	Duel.SetTargetCard(sg)
	Duel.SetCardOperationInfo(sg,CATEGORY_TOHAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	if #g>0 then
		Duel.Search(g)
	end
end

--E2
function s.pcfilter(c,tp)
	return c:IsCode(id) and c:IsType(TYPE_CONTINUOUS) and c:IsCanBePlacedOnField(tp)
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExists(false,s.pcfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp)
	end
end
function s.pcop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.Necro(s.pcfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end