--无为觉者
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(POS_FACEUP,0)
	e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e0:SetValue(id+SUMMON_TYPE_SPECIAL)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(s.spcost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e2:SetValue(0xff)
	c:RegisterEffect(e2)
	--base attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e6)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e7:SetCondition(s.wincon)
	e7:SetOperation(s.winop)
	c:RegisterEffect(e7)
	--level up
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_ATTACK_ANNOUNCE)
	e8:SetTarget(s.lvtg)
	e8:SetOperation(s.lvop)
	c:RegisterEffect(e8)
	if not s.Card_Level then
		s.Card_Level=1
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.matfilter(c)
	return c:IsLevelAbove(0) and c:IsAbleToDeckOrExtraAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,0,nil)
	return g:GetCount()>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_MZONE,0,1,99,nil)
	c:SetMaterial(sg)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetOperation(s.splvop)
	c:RegisterEffect(e1)
end
function s.splvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Card.SetCardData then
		c:SetCardData(5,s.Card_Level)
	end
	e:Reset()
end
function s.spcost(e,c,tp,st)
	return st==id+SUMMON_TYPE_SPECIAL or st==0
end
function s.atkval(e,c)
	local g=c:GetMaterial()
	local atk=g:GetSum(Card.GetBaseAttack,nil)
	--local def=g:GetSum(Card.GetBaseDefense,nil)
	return atk/2
end
function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalLevel()==7
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Win(tp,0x0)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return KOISHI_CHECK end
end
function s.lvfilter(c)
	return c:GetOriginalCodeRule()==id
end
function s.cfilter(c,tp)
	return c:IsLocation(LOCATION_EXTRA) and c:IsControler(tp)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	s.Card_Level=s.Card_Level+1
	if KOISHI_CHECK then
		local g=Duel.GetFieldGroup(tp,0xff,0xff)
		local xg=Duel.GetFieldGroup(tp,0x4d,0x4d)
		for xc in aux.Next(xg) do
			g:Merge(xc:GetOverlayGroup())
		end
		g=g:Filter(s.lvfilter,nil)
		for tc in aux.Next(g) do
			tc:SetCardData(5,s.Card_Level)
		end
		for p=0,1 do
			if g:IsExists(s.cfilter,1,nil,p) then
				Duel.ShuffleExtra(p)
				--Duel.ConfirmCards(p,Duel.GetFieldGroup(p,LOCATION_EXTRA,0))
			end			 
		end
	end
end





