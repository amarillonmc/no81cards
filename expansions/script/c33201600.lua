--御溟枢机-不落要塞
---------------Functions and Filters--------------------
VHisc_YMSJ=VHisc_YMSJ or {}

---------------Register SYNCHRO effect---------------

function VHisc_YMSJ.synsm(ce,ccode,lv) 
	ce:EnableReviveLimit()  
	--special summon rule
	local e0=Effect.CreateEffect(ce)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabel(ccode,lv)
	e0:SetCondition(VHisc_YMSJ.spcon)
	e0:SetTarget(VHisc_YMSJ.sptg)
	e0:SetOperation(VHisc_YMSJ.spop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	ce:RegisterEffect(e0)
end

--syn
function VHisc_YMSJ.synfilter(c,sc)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and (c:IsNotTuner(sc) or c:IsSetCard(0x5327)) and c:IsLevelAbove(0) and c:IsAbleToGrave() and c:IsCanBeSynchroMaterial(sc)
end
function VHisc_YMSJ.cck(c)
	return c:IsSetCard(0x5327)
end

function VHisc_YMSJ.fselect(g,tp,sc,smat,slv)
	if not g:IsExists(VHisc_YMSJ.cck,1,nil) then return false end
	local lv=0
	local smatck=true 
	if smat and not g:IsContains(smat) then
		smatck=false
	end
	local tc=g:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=g:GetNext()
	end
	return smatck  and lv==slv and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end

function VHisc_YMSJ.spcon(e,c,smat,mg1,min,max)
	if c==nil then return true end
	local id,lv=e:GetLabel()
	local tp=c:GetControler()
------------------------MustMaterialCheck---------------------------------------
				local mg
				if smat and not smat:IsCanBeSynchroMaterial(c) then
					return false
				end
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
				else
					mg=Duel.GetMatchingGroup(VHisc_YMSJ.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
				end
				if smat~=nil then 
					mg:AddCard(smat) 
				end
-----------------------------------------------------------------------------------
	return Duel.GetFlagEffect(tp,id)==0 and mg:CheckSubGroup(VHisc_YMSJ.fselect,2,2,tp,c,smat,lv)
end
function VHisc_YMSJ.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local id,lv=e:GetLabel()
------------------------MustMaterialCheck---------------------------------------
				local mg
				if smat and not smat:IsCanBeSynchroMaterial(c) then
					return false
				end
				if mg1 then
					mg=mg1:Filter(Card.IsCanBeSynchroMaterial,nil,c)
				else
					mg=Duel.GetMatchingGroup(VHisc_YMSJ.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e:GetHandler())
				end
				if smat~=nil then 
					mg:AddCard(smat) 
				end
-----------------------------------------------------------------------------------
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,VHisc_YMSJ.fselect,Duel.IsSummonCancelable(),2,2,tp,c,smat,lv)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function VHisc_YMSJ.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local id,lv=e:GetLabel()
	local tg=e:GetLabelObject()
	Duel.Hint(HINT_CARD,tp,id)
	c:SetMaterial(tg)
	Duel.SendtoGrave(tg,REASON_MATERIAL)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	tg:DeleteGroup()
end

------------------------------------------------------------------------------------------


-------------------------card effect------------------------------
local m=33201600
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(cm.sptarget)
	e1:SetOperation(cm.spoperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
--e1
function cm.filter(c,e,tp)
	return c:IsSetCard(0x5327) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--e2
function cm.disfilter(c)
	return c:IsSetCard(0x5327) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_MZONE,0,1,nil)
end 
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
