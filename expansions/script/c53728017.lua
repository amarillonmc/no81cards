local m=53728017
local cm=_G["c"..m]
cm.name="巨征啼鸟 莱茵幻影"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e,c,og,min,max)
				if c==nil then return true end
				local tp=c:GetControler()
				return Duel.CheckXyzMaterial(c,cm.xyzfilter,4,2,99,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
			end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then return true end
				local g=Duel.SelectXyzMaterial(tp,c,cm.xyzfilter,4,2,99,Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0))
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local sg=Group.CreateGroup()
				if og and not min then
					for tc in aux.Next(og) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					for tc in aux.Next(mg) do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(function(e,c,rc)if rc==e:GetHandler() then return c:GetOriginalLevel() else return c:GetLevel()end end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)end)
	e2:SetTarget(cm.tftg)
	e2:SetOperation(cm.tfop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+50)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.xyzfilter(c)
	return c:IsFaceup() and (c:GetOriginalType()&TYPE_UNION~=0 or not c:IsLocation(LOCATION_MZONE)) and (c:IsType(TYPE_UNION) or not c:IsLocation(LOCATION_SZONE))
end
function cm.tffilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(function(c,e,tp)return c:IsSetCard(0xc532) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)end,nil,e,tp)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,#g,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,#g,#g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(function(c,e,tp)return c:IsSetCard(0xc532) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)end,nil,e,tp)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=#g end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE) end
end
