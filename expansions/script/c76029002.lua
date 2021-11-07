--轰击之铁御 灰毫
function c76029002.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76029002,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c76029002.ntcon)
	e1:SetOperation(c76029002.ntop)
	c:RegisterEffect(e1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c76029002.eqtg)
	e1:SetOperation(c76029002.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16029002) 
	e2:SetTarget(c76029002.detg)
	e2:SetOperation(c76029002.deop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,16029002) 
	e3:SetTarget(c76029002.detg)
	e3:SetOperation(c76029002.deop)
	c:RegisterEffect(e3)
end
c76029002.named_with_Kazimierz=true 
function c76029002.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5)
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c76029002.ntop(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,1))
	Debug.Message("听从您的调遣。")
end
function c76029002.filter(c)
	return c:IsRace(RACE_BEASTWARRIOR+RACE_WINDBEAST) and not c:IsForbidden()
end
function c76029002.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c76029002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c76029002.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c76029002.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,2))
	Debug.Message("准备好，对手接近了！")
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c76029002.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c76029002.eqlimit(e,c)
	return e:GetOwner()==c
end
function c76029002.detg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local x1=Duel.GetMatchingGroupCount(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,1,nil) and x1>0 end  
	if x1>2 then x1=2 end 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_REMOVED,0,1,x1,nil)
	local x=g:GetCount()
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(x)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,x,0,LOCATION_ONFIELD)
end
function c76029002.deop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local x=e:GetLabel()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>=x then 
	local dg=g:Select(tp,x,x,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,3))
	Debug.Message("战斗可没有点到为止的说法。")
	end
end
