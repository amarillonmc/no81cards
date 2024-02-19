--[[
「黑之进军」
==【- The Black Parade -】==
==【- La Parata Nera -】==
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Equip only to a Psychic monster
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)
	--[[● 1+: If exactly 1 card you control is sent to the GY (except during the Damage Step, unless at the end of the Damage Step):
	You can pay 1000 LP and send 1 "- The Black Parade -" from your Deck to the GY; Set that sent card from your GY to your field.]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_TO_GRAVE,s.cfilter,id,LOCATION_SZONE,nil,LOCATION_SZONE)
	local e3=Effect.CreateEffect(c)
	e3:Desc(0)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--[[Each time a card(s) you control is destroyed by your opponent: Take 1000 damage, and if you do, inflict 500 damage to your opponent for each card that was destroyed.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(1)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(s.damcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
	--[[After damage calculation, if the equipped monster battled another monster: You can take 2000 damage, and if you do,
	inflict damage to your opponent equal to that monster's ATK, also send it to the GY.]]
	local e5=Effect.CreateEffect(c)
	e5:Desc(2)
	e5:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(s.tgcon)
	e5:SetTarget(s.tgtg)
	e5:SetOperation(s.tgop)
	c:RegisterEffect(e5)
	--[[During the End Phase, if this card is in your GY: You can shuffle it into your Deck, and if you do, add 1 "- The White March -" from your Deck or GY to your hand.]]
	local e6=Effect.CreateEffect(c)
	e6:Desc(3)
	e6:SetCategory(CATEGORIES_SEARCH|CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE|PHASE_END)
	e6:SetRange(LOCATION_GRAVE)
	e6:OPT()
	e6:SetTarget(s.tdtg)
	e6:SetOperation(s.tdop)
	c:RegisterEffect(e6)
end
--E1
function s.filter(c)
	if not c:IsFaceup() then return false end
	return c:IsRace(RACE_PSYCHIC)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToChain() and tc:IsRelateToChain() and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--E2
function s.eqlimit(e,c)
	return c:IsRace(RACE_PSYCHIC)
end

--E3
function s.cfilter(c,_,tp,eg,ep,ev,re,r,rp,se)
	return #eg==1 and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or c:IsReason(REASON_BATTLE)) and c:IsControler(tp) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and (se==nil or c:GetReasonEffect()~=se)
end
function s.tgcfilter(c)
	return c:IsCode(id) and c:IsAbleToGraveAsCost()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return not eg:IsContains(c) and ec and ec:GetEquipGroup():IsExists(aux.FaceupFilter(Card.IsCode,id),1,nil)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(s.tgcfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgcfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.spfilter(c,e,tp)
	if not aux.PLChk(c,tp,LOCATION_GRAVE) then return false end
	if c:GetOriginalType()&TYPE_MONSTER>0 then
		return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else
		return c:IsSSetable()
	end
end
function s.excfilter(c,typ)
	return c:GetOriginalType()&typ~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.spfilter,nil,e,tp)
	if chk==0 then
		return #g>0
	end
	Duel.SetTargetCard(g)
	e:SetCategory(0)
	if not g:IsExists(s.excfilter,1,nil,TYPE_ST) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)	
	elseif not g:IsExists(s.excfilter,1,nil,TYPE_MONSTER) then
		e:SetCategory(0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,0)	
	else
		e:SetCategory(CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards():Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp)
	if #g<=0 then return end
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		g=g:Select(tp,1,1,nil)
	end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc:IsMonster() then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SSet(tp,tc)
	end
end

--E4
function s.rcfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==1-tp
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec and ec:GetEquipGroup():IsExists(aux.FaceupFilter(Card.IsCode,id),2,nil) and eg:IsExists(s.rcfilter,1,nil,tp)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=eg:FilterCount(s.rcfilter,nil,tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
	Duel.SetAdditionalOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,1000,REASON_EFFECT,true)>0 then
		local ct=Duel.GetTargetParam()
		if ct and ct>0 then
			Duel.Damage(1-tp,ct*500,REASON_EFFECT,true)
		end
	end
	Duel.RDComplete()
end

--E5
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then return false end
	local bc=ec:GetBattleTarget()
	return ec:GetEquipGroup():IsExists(aux.FaceupFilter(Card.IsCode,id),2,nil) and bc and bc:IsRelateToBattle() and bc:IsFaceup()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if chk==0 then return bc:IsRelateToBattle() and bc:IsAbleToGrave() end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,bc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,bc,1,0,0)
	Duel.SetAdditionalOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local needcompletion=true
	if Duel.Damage(tp,2000,REASON_EFFECT,true)>0 then
		local c=e:GetHandler()
		local ec=c:GetEquipTarget()
		if ec and ec:IsRelateToBattle() then
			local bc=ec:GetBattleTarget()
			if bc and bc:IsRelateToBattle() and bc:IsRelateToChain() then
				if bc:IsFaceup() then
					local ct=bc:GetAttack()
					if ct and ct>0 then
						Duel.Damage(1-tp,ct,REASON_EFFECT,true)
						Duel.RDComplete()
						needcompletion=false
					end
				end
				if needcompletion then
					Duel.RDComplete()
					needcompletion=false
				end
				Duel.SendtoGrave(bc,REASON_EFFECT)
			end
		end
	end
	if needcompletion then
		Duel.RDComplete()
	end
end

--E6
function s.thfilter(c)
	return c:IsCode(id-1) and c:IsAbleToHand()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.ShuffleIntoDeck(c)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.Necro(s.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.Search(g,tp)
		end
	end
end