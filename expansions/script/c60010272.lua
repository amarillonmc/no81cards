--胧月夜
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010261)
	aux.EnableChangeCode(c,60010261,LOCATION_MZONE)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.imtg)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e2)
	local e1=e3:Clone()
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
	c:RegisterEffect(e11)

	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_TOKEN+CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_SUMMON_SUCCESS)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(cm.tkcon)
	e11:SetTarget(cm.tktg)
	e11:SetOperation(cm.tkop)
	c:RegisterEffect(e11)
	local e22=e11:Clone()
	e22:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e22)
end
function cm.fil1(c)
	return c:IsCode(60010261) and c:IsFaceup()
end
function cm.fil2(c)
	return aux.IsCodeListed(c,60010261) and c:IsDiscardable(REASON_COST)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(cm.fil1,nil)
	return rg:CheckSubGroup(aux.mzctcheckrel,1,1,tp,REASON_SPSUMMON) and Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_HAND,0,2,e:GetHandler())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(cm.fil1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,1,1,tp,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SelectMatchingCard(tp,cm.fil2,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	if sg and Duel.SendtoGrave(dg,REASON_DISCARD+REASON_COST) then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	Debug.Message("胧夜月明之时，凛冽惊风骤起，万阵破势而来。")
	g:DeleteGroup()
end
function cm.imtg(e,c)
	local tc=e:GetHandler()
	return tc:GetAttribute()&c:GetAttribute()>0
end

function cm.cfilter2(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH,ATTRIBUTE_FIRE,ATTRIBUTE_WATER,ATTRIBUTE_WIND)
end
function cm.cfilter3(c)
	return c:IsFaceup() --and not c:IsAttack(0)
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter2,1,e:GetHandler(),tp)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local ec=eg:Filter(cm.cfilter2,nil,tp):GetFirst()
	if #eg:Filter(cm.cfilter2,nil,tp)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		ec=eg:Select(tp,1,1,nil):GetFirst()
	end
	if not ec then return end
	local attr=ec:GetAttribute()
	if attr&ATTRIBUTE_FIRE>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		local token=Duel.CreateToken(tp,60010261+1)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local ag=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		for tc in aux.Next(ag) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(2000)
			tc:RegisterEffect(e1)
		end
	end
	if attr&ATTRIBUTE_WATER>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>7 then
		local token=Duel.CreateToken(tp,60010261+2)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.SortDecktop(tp,tp,8)
	end
	if attr&ATTRIBUTE_WIND>0 and Duel.IsExistingMatchingCard(cm.cfilter3,tp,0,LOCATION_MZONE,1,nil) then
		local token=Duel.CreateToken(tp,60010261+3)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local tc=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-1600)
		tc:RegisterEffect(e1)
		if tc:IsAttack(0) then Duel.Destroy(tc,REASON_EFFECT) end
	end
	if attr&ATTRIBUTE_EARTH>0 then
		local token=Duel.CreateToken(tp,60010261+4)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Recover(tp,3200,REASON_EFFECT)
	end
end