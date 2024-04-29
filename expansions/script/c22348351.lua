--绰 影 骸 骨 团 ·士 兵
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
local m=22348351
local cm=_G["c"..m]
function cm.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22348351)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c22348351.sptg)
	e1:SetOperation(c22348351.spop)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x970a))
	e2:SetValue(c22348351.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	c22348351.bfg_effect=e1
	--spe1
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348359,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22348351)
	e4:SetCondition(c22348351.thcon)
	e4:SetCost(c22348351.thcost)
	e4:SetTarget(c22348351.sptg)
	e4:SetOperation(c22348351.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	
	--cee2
	local e6=e4:Clone()
	e6:SetDescription(aux.Stringid(22348360,2))
	e6:SetCode(EVENT_TO_HAND)
	e6:SetCondition(c22348351.cee2con)
	e6:SetCost(c22348351.cee2cost)
	c:RegisterEffect(e6)
	
	--cee3
	local e7=e4:Clone()
	e7:SetDescription(aux.Stringid(22348361,2))
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCondition(c22348351.cee3con)
	e7:SetCost(c22348351.cee3cost)
	c:RegisterEffect(e7)
	
	--cee4
	local e8=e4:Clone()
	e8:SetDescription(aux.Stringid(22348362,2))
	e8:SetCode(EVENT_LEAVE_GRAVE)
	e8:SetCondition(c22348351.cee4con)
	e8:SetCost(c22348351.cee4cost)
	c:RegisterEffect(e8)
	
	--cee5
	local e9=e4:Clone()
	e9:SetDescription(aux.Stringid(22348413,2))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_CHAINING)
	e9:SetCondition(c22348351.cee5con)
	e9:SetCost(c22348351.cee5cost)
	c:RegisterEffect(e9)
	--cee6
	local e10=e4:Clone()
	e10:SetDescription(aux.Stringid(22348414,2))
	e10:SetCode(EVENT_ATTACK_ANNOUNCE)
	e10:SetCondition(c22348351.cee6con)
	e10:SetCost(c22348351.cee6cost)
	c:RegisterEffect(e10)

	
end
function c22348351.cee6con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22348351.costfilter6,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter6(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348414,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.cee6cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter6,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter6,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348414,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end
function c22348351.cee5con(e,tp,eg,ep,ev,re,r,rp)
	return  rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and Duel.IsExistingMatchingCard(c22348351.costfilter5,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter5(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348413,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.cee5cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter5,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter5,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348413,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end
function c22348351.cee4con(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsExistingMatchingCard(c22348351.costfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter4(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348362,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.cee4cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348362,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end




function c22348351.cfilter3(c,tp)
	return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function c22348351.cee3con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348351.cfilter3,1,e:GetHandler(),tp) and Duel.IsExistingMatchingCard(c22348351.costfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter3(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348361,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.cee3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348361,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end




function c22348351.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22348351.cee2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348351.cfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348351.costfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter2(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348360,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.cee2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348360,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end



function c22348351.thconfilter(c,sp)
	return c:IsSummonPlayer(sp)
end
function c22348351.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348351.thconfilter,1,nil,1-tp) and Duel.IsExistingMatchingCard(c22348351.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348351.costfilter(c,e,tp)
	return e:GetHandler():IsSetCard(0xd70a) and c:IsHasEffect(22348359,tp) and c:IsAbleToRemoveAsCost()
end
function c22348351.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348351.costfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c22348351.costfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local te=tg:GetFirst():IsHasEffect(22348359,tp)
	te:UseCountLimit(tp)
	Duel.Remove(tg,POS_FACEUP,REASON_REPLACE)
end




function c22348351.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c22348351.val(e,c)
	return Duel.GetMatchingGroupCount(c22348351.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*100
end
function c22348351.filter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348351.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348351.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c22348351.spop(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c22348351.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,2))
	if sg:GetCount()>0 then
		res=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	chuoying.gaixiaoguo1(e,tp,res)
	chuoying.gaixiaoguo2(e,tp,res)
	chuoying.gaixiaoguo3(e,tp,res)
	chuoying.gaixiaoguo4(e,tp,res)
	chuoying.gaixiaoguo5(e,tp,res)
	chuoying.gaixiaoguo6(e,tp,res)
end

