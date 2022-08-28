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
	e1:SetCountLimit(1,76029002) 
	e1:SetTarget(c76029002.eqtg)
	e1:SetOperation(c76029002.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--da 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c76029002.eqcheck)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetLabelObject(e3) 
	e4:SetCountLimit(1,16029002) 
	e4:SetTarget(c76029002.datg)
	e4:SetOperation(c76029002.daop)
	c:RegisterEffect(e4)
	local e5=e4:Clone() 
	e5:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e5) 
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
function c76029002.eqcheck(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():DeleteGroup() end
	local g=e:GetHandler():GetEquipGroup()
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c76029002.datg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=e:GetLabelObject():GetLabelObject()
	if chk==0 then return g:GetCount()>0 end   
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c76029002.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local g=e:GetLabelObject():GetLabelObject()
	if g:GetCount()>0 then 
	Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,3))
	Debug.Message("战斗可没有点到为止的说法。")
	end
end




