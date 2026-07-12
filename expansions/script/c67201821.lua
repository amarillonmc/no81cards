--银白之都的秘书 边沁
local s,id,o=GetID()
function c67201821.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--at
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,67201822)
	e3:SetCondition(s.mvcon2)
	e3:SetCost(s.drcost)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)	 
end
--
function s.filter1(c)
	return c:IsSetCard(0x667f) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.filter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()==1-tp and not c:IsForbidden()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_DECK,0,1,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_DECK,0,c)
	local gg=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tcc=gg:SelectUnselect(nil,tp,false,true,1,1)
	if tc and tcc then
		local ggg=Group.CreateGroup()
		Group.AddCard(ggg,tc)
		Group.AddCard(ggg,tcc)
		ggg:KeepAlive()
		e:SetLabelObject(ggg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ggg=e:GetLabelObject()
	local tc1=ggg:GetFirst()
	local tc2=ggg:GetNext()
	if Duel.MoveToField(tc1,tp,tc1:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		if Duel.MoveToField(tc2,tp,tc2:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc2:RegisterEffect(e1)
			--tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc1:RegisterEffect(e2)
		--tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
--
function s.mvcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) 
end
function s.drfilter(c)
	return c:IsSetCard(0x667f) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost() and c:IsFaceupEx()
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.drfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local ct=1
	if Duel.IsPlayerCanDraw(tp,2) then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.drfilter,tp,LOCATION_ONFIELD,0,1,ct,nil)
	e:SetLabel(Duel.SendtoGrave(g,REASON_COST))
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
