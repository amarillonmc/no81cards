--动物朋友 西六线风鸟
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=33701355
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_DECK)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+33700000)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local f1=function(tp,re,rp)
		return tp~=rp
	end
	local e2=rsef.QO(c,EVENT_CHAINING,{m,1},1,"tg,neg","dsp,dcal",LOCATION_MZONE,rscon.negcon(f1),nil,cm.tg2,cm.op2)
	if not aux.Monster_Friend_Excavate_check then
		aux.Monster_Friend_Excavate_check=true
		_confirmdeckgroup=Duel.ConfirmDecktop
		function Duel.ConfirmDecktop(tp,count)
			local re,rp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			local eg=Duel.GetDecktopGroup(tp,count)
			Duel.RaiseEvent(eg,EVENT_CUSTOM+33700000,re,0,rp,tp,count)
			return _confirmdeckgroup(tp,count)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x442) and eg:IsContains(e:GetHandler()) and eg:GetClassCount(Card.GetCode)==#eg
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<15 then return false end
		local g=Duel.GetDecktopGroup(tp,15)
		return g:FilterCount(Card.IsAbleToGrave,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local codect=rg:GetClassCount(Card.GetCode)
	if #rg<=0 or codect<#rg then return end
	local f=function(rc)
		return rc:IsSetCard(0x442) and rc:IsAbleToGrave() and rc:IsType(TYPE_MONSTER)
	end
	if rg:IsExists(f,3,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		if Duel.SendtoGrave(rg,REASON_EFFECT)~=0 then
			Duel.NegateActivation(ev)
		end
	end
end