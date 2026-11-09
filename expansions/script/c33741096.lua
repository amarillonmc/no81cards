--Slicy and Dicey
function c33741096.initial_effect(c)
	c:EnableCounterPermit(0x465)
	c:EnableCounterPermit(0x466)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_COUNTER+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33741096.target)
	e1:SetOperation(c33741096.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33741096,7))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33741096.reccost)
	e2:SetTarget(c33741096.rectg)
	e2:SetOperation(c33741096.recop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33741096,8))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c33741096.tktg)
	e3:SetOperation(c33741096.tkop)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function c33741096.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c33741096.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end--Duel.IsExistingMatchingCard(c33741096.rmfilter,tp,LOCATION_DECK,0,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c33741096.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	c:AddCounter(0x465,1)
	c:RegisterFlagEffect(33741096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,d,aux.Stringid(33741096,d))
	if Duel.IsExistingMatchingCard(c33741096.rmfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,c33741096.rmfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		local attr,race=tc:GetAttribute(),tc:GetRace()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local ct=math.floor((tc:GetAttack()+tc:GetDefense())/100)
		if ct>0 then c:AddCounter(0x466,ct) end
		e:SetLabel(d,attr,race)
	else
		e:SetLabel(d)
	end
end
function c33741096.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x466,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local ct=e:GetHandler():GetCounter(0x466)
	local t={1}
	for i=2,ct do if e:GetHandler():IsCanRemoveCounter(tp,0x466,i,REASON_COST) then t[i]=i end end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33741096,0))
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	e:GetHandler():RemoveCounter(tp,0x466,ac,REASON_COST)
	e:SetLabel(ac)
end
function c33741096.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel()*100)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel()*100)
end
function c33741096.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c33741096.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x466)
	local d,attr,race=e:GetLabelObject():GetLabel()
	if chk==0 then return d>0 and attr~=0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33741076,0,TYPES_TOKEN_MONSTER,ct*100,ct*100,2,race,attr) and Duel.GetMZoneCount(tp)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33741096.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x466)
	local d,attr,race=e:GetLabelObject():GetLabel()
	d=d-1
	e:GetLabelObject():SetLabel(d,attr,race)
	e:GetHandler():ResetFlagEffect(33741096)
	if d==0 then
		e:GetHandler():RemoveCounter(tp,0x465,1,REASON_RULE)
	else
		e:GetHandler():RegisterFlagEffect(33741096,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,d,aux.Stringid(33741096,d))
	end
	if Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,33741076,0,TYPES_TOKEN_MONSTER,ct*100,ct*100,2,race,attr) then return end
	local token=Duel.CreateToken(tp,33741076)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(race)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(attr)
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(ct*100)
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetValue(ct*100)
	token:RegisterEffect(e4)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
