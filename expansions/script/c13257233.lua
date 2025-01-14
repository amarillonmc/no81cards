--宇宙战争机器 信标
local m=13257233
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetRange(LOCATION_DECK)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e11)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.regcost)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.dreptg)
	c:RegisterEffect(e2)
	--deck equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.eqtg)
	e4:SetOperation(cm.eqop)
	c:RegisterEffect(e4)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetOperation(cm.bgmop)
	c:RegisterEffect(e12)
	eflist={{"deck_equip",e4},{"core_level",5}}
	cm[c]=eflist
	Duel.AddCustomActivityCounter(13257233,ACTIVITY_NORMALSUMMON,cm.counterfilter)
	Duel.AddCustomActivityCounter(13257233,ACTIVITY_SPSUMMON,cm.counterfilter)
	
end
function cm.counterfilter(c)
	return c:IsSetCard(0x353)
end
function cm.regcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetLocation()==LOCATION_HAND and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_NORMALSUMMON)==0 and not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(c)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e4,tp)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e5,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x353)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)~=0 then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not c:IsDisabled() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE_EFFECT)
		e5:SetValue(RESET_TURN_SET)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5,true)
		return true
	else return false end
end
function cm.eqfilter(c,ec)
	return c:IsSetCard(0x354) and c:IsType(TYPE_MONSTER) and c:CheckEquipTarget(ec)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,4))
end
