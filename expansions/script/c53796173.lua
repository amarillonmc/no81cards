local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetLabelObject(g)
	e3:SetOperation(s.merge)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(s.delay)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+id)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(s.con)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(s.tg)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsLevel(1) and c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function s.merge(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(sg) do
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetAttack())
			tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetDefense())
		end
		local atk=math.abs(tc:GetAttack()-tc:GetFlagEffectLabel(id))
		local def=math.abs(tc:GetDefense()-tc:GetFlagEffectLabel(id+500))
		local sum=e:GetLabel()
		if atk>0 or def>0 then g:AddCard(tc) e:SetLabel(sum+atk+def) end
		tc:SetFlagEffectLabel(id,tc:GetAttack())
		tc:SetFlagEffectLabel(id+500,tc:GetDefense())
	end
	if #g==0 then return end
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,e:GetLabel())
		g:Clear()
		e:SetLabel(0)
	end
end
function s.delay(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,e:GetLabel())
		g:Clear()
		e:SetLabel(0)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local bt=Duel.GetAttacker()
	return ev>0 and bt and bt:IsControler(tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttacker())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsFacedown() or not a:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(ev)
	a:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	a:RegisterEffect(e3)
end
