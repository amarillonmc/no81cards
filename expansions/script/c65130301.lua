--时空掌握者
list = {1,2,3,4,5,6,7,8,9,10}
function c65130301.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65130301,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(c65130301.thcon)
	e1:SetOperation(c65130301.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c65130301.spcon)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)
	--atk,def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(c65130301.value)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(c65130301.ranop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(65130301,0))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,65130301)
	e7:SetTarget(c65130301.copytg)
	e7:SetOperation(c65130301.copy)
	c:RegisterEffect(e7)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
--random seed
local A=1103515245
local B=12345
local M=32767
function roll(min,max)
	if not random_seed then
		local g=Duel.GetFieldGroup(0,0xff,0xff):RandomSelect(2,1)
		random_seed=g:GetFirst():GetCode()+Duel.GetTurnCount()+Duel.GetFieldGroupCount(1,LOCATION_GRAVE,0)
	end
	min=tonumber(min)
	max=tonumber(max)
	random_seed=((random_seed*A+B)%M)/M
	if min~=nil then
		if max==nil then
			return math.floor(random_seed*min)+1
		else
			max=max-min+1
			return math.floor(random_seed*max+min)
		end
	end
	return random_seed
end
function c65130301.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c65130301.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_MAIN1)
	c:RegisterEffect(e1)
	local num = roll(0,9)+1 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(num)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(65130301,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)   
end
function c65130301.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetLevel()<= Duel.GetTurnCount()
end
function c65130301.value(e,c)
	return c:GetLevel()*500
end
function c65130301.createlist()
	list = {1,2,3,4,5,6,7,8,9,10}
end
function c65130301.randomlist()
	local k =roll(1,#list)
	local num=list[k]
	table.remove(list,k)
	return num
end
function c65130301.ranop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c65130301.createlist()
	local lv = c:GetLevel()
	for i=1,lv do
		local No=c65130301.randomlist()
		if No==1 then 
			Duel.Draw(tp,2,REASON_EFFECT)
		end
		if No==2 then 
			Duel.Damage(1-tp,800,REASON_EFFECT)
		end
		if No==3 then 
			Duel.Recover(tp,1600,REASON_EFFECT)
		end
		if No==4 then 
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(65130301,4))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DIRECT_ATTACK)
			c:RegisterEffect(e1)
		end
		if No==5 then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetDescription(aux.Stringid(65130301,5))
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			c:RegisterEffect(e2)
		end
		if No==6 then 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetDescription(aux.Stringid(65130301,6))
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)
			c:RegisterEffect(e1)
		end
		if No==7 then 
			local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if g:GetCount()>0 then
				local sg=g:RandomSelect(tp,1)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
		if No==8 then 
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil,tp,POS_FACEDOWN)
			if g:GetCount()==0 then return end
			local rg=g:RandomSelect(tp,1)
			local tc=rg:GetFirst()
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			tc:RegisterFlagEffect(65130301,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			e1:SetCondition(c65130301.retcon)
			e1:SetOperation(c65130301.retop)
			Duel.RegisterEffect(e1,tp)
		end
		if No==9 then 
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(65130301,9))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetRange(LOCATION_MZONE)
			c:RegisterEffect(e1)
		end
		if No==10 then 
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(65130301,10))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetTargetRange(1,0)
			e1:SetValue(0)
			c:RegisterEffect(e1)
		end
	end
end
function c65130301.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(65130301)==0 then
		e:Reset()
		return false
	else
		return Duel.GetTurnPlayer()==1-tp
	end
end
function c65130301.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
function c65130301.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,10)
	if chk==0 then return true
	--g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==10
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c65130301.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,10)
	--if g:GetCount()<10 then return end 
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	if KOISHI_CHECK then
		Duel.Hint(HINT_CARD,0,65130302)
		c:SetEntityCode(65130302,true)
	end
	local g=Group.CreateGroup()
	for i=1,10 do
		local cc=Duel.CreateToken(tp,65130301)
		g:AddCard(cc)
	end
	Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_RULE)
end