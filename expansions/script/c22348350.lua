--绰 影 骸 骨 团 ·暴 徒
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c22348342") end) then require("script/c22348342") end
local m=22348350
local cm=_G["c"..m]
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22348350)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c22348350.thtg)
	e1:SetOperation(c22348350.thop)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x970a))
	e2:SetValue(c22348350.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	c22348350.bfg_effect=e1
	--spe1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348359,2))
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22348350)
	e4:SetCondition(c22348350.thcon)
	e4:SetCost(c22348350.thcost)
	e4:SetTarget(c22348350.thtg)
	e4:SetOperation(c22348350.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--cee2
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(22348360,2))
	e6:SetCode(EVENT_TO_HAND)
	e6:SetCondition(c22348350.cee2con)
	e6:SetCost(c22348350.cee2cost)
	c:RegisterEffect(e6)
	--cee3
	local e7=e4:Clone()
	e7:SetDescription(aux.Stringid(22348361,2))
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCondition(c22348350.cee3con)
	e7:SetCost(c22348350.cee3cost)
	c:RegisterEffect(e7)
	--cee4
	local e8=e4:Clone()
	e8:SetDescription(aux.Stringid(22348362,2))
	e8:SetCode(EVENT_LEAVE_GRAVE)
	e8:SetCondition(c22348350.cee4con)
	e8:SetCost(c22348350.cee4cost)
	c:RegisterEffect(e8)
	--cee5
	local e9=e4:Clone()
	e9:SetDescription(aux.Stringid(22348413,2))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetCondition(c22348350.cee5con)
	e9:SetCost(c22348350.cee5cost)
	c:RegisterEffect(e9)
	--cee6
	local e10=e4:Clone()
	e10:SetDescription(aux.Stringid(22348414,2))
	e10:SetCode(EVENT_ATTACK_ANNOUNCE)
	e10:SetCondition(c22348350.cee6con)
	e10:SetCost(c22348350.cee6cost)
	c:RegisterEffect(e10)

	
end
function c22348350.cee6con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22348350.costfilter6,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter6(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348414,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.cee6cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter6,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter6,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348414,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end


function c22348350.cee5con(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and Duel.IsExistingMatchingCard(c22348350.costfilter5,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter5(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348413,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.cee5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter5,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter5,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348413,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end


function c22348350.cee4con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c22348350.costfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter4(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348362,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.cee4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348362,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end




function c22348350.cfilter3(c,tp)
	return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c22348350.cee3con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348350.cfilter3,1,e:GetHandler(),tp) and Duel.IsExistingMatchingCard(c22348350.costfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter3(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348361,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.cee3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348361,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end


function c22348350.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22348350.cee2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348350.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348350.costfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter2(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348360,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.cee2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348360,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end


function c22348350.thconfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c22348350.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348350.thconfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348350.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348350.costfilter(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348359,tp) and c:IsAbleToRemoveAsCost()
end
function c22348350.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348350.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348350.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348359,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end
function c22348350.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c22348350.val(e,c)
	return Duel.GetMatchingGroupCount(c22348350.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end

function c22348350.filter(c)
	return c:IsSetCard(0x970a)
end
function c22348350.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c22348350.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348350.thop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	if Duel.DiscardHand(tp,c22348350.filter,1,1,REASON_EFFECT)~=0 and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		if dc:IsSetCard(0x970a) then
			Duel.BreakEffect()
			res=Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
	chuoying.gaixiaoguo1(e,tp,res)
	chuoying.gaixiaoguo2(e,tp,res)
	chuoying.gaixiaoguo3(e,tp,res)
	chuoying.gaixiaoguo4(e,tp,res)
	chuoying.gaixiaoguo5(e,tp,res)
	chuoying.gaixiaoguo6(e,tp,res)
end
