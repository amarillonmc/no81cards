--大梦之咏叹调
Duel.LoadScript("c60002355.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(Aria.ytdcost)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(Aria.scon)
	e3:SetCost(Aria.ytdcost)
	e3:SetTarget(Aria.stg)
	e3:SetOperation(Aria.sop)
	c:RegisterEffect(e3)
	--bk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetCondition(Aria.scon2)
	e3:SetCost(Aria.ytdcost)
	e3:SetTarget(cm.stg)
	e3:SetOperation(cm.sop)
	c:RegisterEffect(e3)
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60002363,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_WYRM,ATTRIBUTE_LIGHT,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60002363,0,TYPES_TOKEN_MONSTER,2000,2000,5,RACE_WYRM,ATTRIBUTE_LIGHT,POS_FACEUP) then return end
	local token=Duel.CreateToken(tp,60002363)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,60002355)>=2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Aria.BackAria(c)
	end
	Duel.SpecialSummonComplete()
	if Duel.GetCurrentChain()>=4 then
		Duel.RegisterFlagEffect(tp,70002355,RESET_PHASE+PHASE_END,0,1)
	end
end