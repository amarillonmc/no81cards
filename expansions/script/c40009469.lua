--龙血师团-龙血眼
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm = rscf.DefineCard(40009469)
if rsdb then return end
rsdb = cm 
rscf.DefineSet(rsdb,0x3f1b)
function rsdb.XyzLimitFun(c,code)
	local e1=rscf.SetSummonCondition(c,false,cm.xyzlimit)
	local e2=rsef.SC(c,EVENT_SPSUMMON_SUCCESS,nil,nil,"cd,uc",nil,cm.xyzregop)
	e2:SetLabel(code)
	return e1,e2
end
function rsdb.XyzFun(c,code,matcode)
	aux.AddCodeList(c,matcode)
	local e1,e2=rsdb.XyzLimitFun(c,code)
	local e3=rscf.AddSpecialSummonProcdure(c,LOCATION_EXTRA,cm.xyzcon,nil,cm.xyzop)
	e3:SetLabel(matcode)
	return e1,e2,e3
end
function rsdb.XyzFun2(c,code,con,op)
	local e1,e2=rsdb.XyzLimitFun(c,code)
	local e3=rscf.AddSpecialSummonProcdure(c,LOCATION_EXTRA,con,nil,op)
	return e1,e2,e3
end
function cm.xyzlimit(e,se,sp,st)
	return st & SUMMON_TYPE_XYZ ~= SUMMON_TYPE_XYZ 
end
function cm.matfilter(c,matcode,tp,xyzc)
	return c:IsCanOverlay() and c:IsCode(matcode) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end
function cm.xyzcon(e,c,tp)
	return Duel.IsExistingMatchingCard(cm.matfilter,tp,LOCATION_MZONE,0,1,nil,e:GetLabel(),tp,c)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	rshint.Select(tp,HINTMSG_XMATERIAL)
	local tc = Duel.SelectMatchingCard(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil,e:GetLabel(),tp,c):GetFirst()
	local mat = tc:GetOverlayGroup()
	if #mat > 0 then
		Duel.Overlay(c,mat)
	end
	Duel.Overlay(c,Group.FromCards(tc))
end
function cm.xyzregop(e,tp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_EXTRA) then
		local e1 = rsef.FV_LIMIT_PLAYER({e:GetHandler(),tp},"sp",nil,cm.xyzlimittg,{1,0},nil,rsreset.pend)
		e1:SetLabel(e:GetLabel())
	end
end
function cm.xyzlimittg(e,c)
	return c:IsCode(e:GetLabel()) and c:IsLocation(LOCATION_EXTRA)
end
--////////
function rsdb.SummonMatFun(c,code,hcate,rcate,filter1,filter2,loc,op)
	local e1=rsef.I(c,"sum",{1,code},"sum",nil,LOCATION_MZONE,cm.smfscon,nil,rsop.target(cm.smfsfilter,"sum",LOCATION_HAND+LOCATION_MZONE),cm.smfsop)
	local e2=rsef.STO(c,EVENT_MOVE,hcate,{1,code},rcate,"de",cm.smfmcon,nil,rsop.target(cm.smfmfilter(filter1,filter2),hcate,loc),cm.smfmop(hcate,loc,filter1,filter2,op))
	return e1,e2
end
function cm.smfscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function cm.smfsfilter(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0x3f1b)
end
function cm.smfsop(e,tp)
	local tc=rsop.SelectSolve(HINTMSG_SUMMON,tp,cm.smfsfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,{}):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.smfmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.smfmmatfilter(c,e)
	return c:IsType(TYPE_XYZ) and c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function cm.smfmfilter(filter1,filter2) 
	return function(c,e,tp)
		return c:IsSetCard(0x3f1b) and filter1(c,e,tp) and (filter2(c,e,tp) or (c:IsCanOverlay() and Duel.IsExistingMatchingCard(cm.smfmmatfilter,tp,LOCATION_MZONE,0,1,nil,e)))
	end
end
function cm.smfmop(cate,loc,filter1,filter2,op)
	return function(e,tp,...)
		local tc = rsop.SelectSolve(HINTMSG_SELF,tp,aux.NecroValleyFilter(cm.smfmfilter(filter1,filter2)),tp,loc,0,1,1,nil,{},e,tp):GetFirst()
		local g = Duel.GetMatchingGroup(cm.smfmmatfilter,tp,LOCATION_MZONE,0,nil,e)
		if not tc then return end
		local b1 = filter2(tc,e,tp)
		local b2 = tc:IsCanOverlay() and #g > 0
		local opt = rsop.SelectOption(tp,b1,cate,b2,{m,0})
		if opt == 1 then
			op(tc,e,tp,...)
		else
			rshint.Select(tp,HINTMSG_FACEUP)
			local xg = g:Select(tp,1,1,nil)
			Duel.HintSelection(xg)  
			Duel.Overlay(xg:GetFirst(),Group.FromCards(tc))
		end
	end
end
--////////
function rsdb.ImmueFun(c,code)
	local e1=rsef.I(c,{m,1},{1,code},nil,nil,LOCATION_MZONE,nil,rscost.rmxyz(1),cm.imftg,cm.imfop)
	return e1
end
function cm.imftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(tp)
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function cm.imfop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1 = rsef.SV_IMMUNE_EFFECT(c,cm.imfval,nil,{rsreset.est_pend,2},"cd")
	e1:SetLabel(e:GetLabel())
end
function cm.imfval(e,re)
	return rsval.imoe(e,re) and re:IsActiveType(e:GetLabel())
end
-----------------------------------
function cm.initial_effect(c)
	local e1=rsef.I(c,"sum",{1,m},"sum",nil,LOCATION_HAND,nil,rscost.lpcost(800),rsop.target(cm.sumfilter,"sum"),cm.sumop)
	local e3=rsef.STO(c,EVENT_SUMMON_SUCCESS,"th",nil,"se,th","de",nil,nil,rsop.target(cm.cfilter,nil,LOCATION_EXTRA),cm.cop)
	local e4=rsef.I(c,"tg",{1,m+100},"tg",nil,LOCATION_MZONE,nil,nil,rsop.target(cm.tgfilter,"tg",LOCATION_HAND),cm.tgop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.ntcon)
	e2:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0)
end
function cm.sumfilter(c,e,tp)
	return c:IsSummonable(true,e:GetLabelObject())
end
function cm.sumop(e,tp)
	local c=rscf.GetSelf(e)
	if not c then return end
	Duel.BreakEffect()
	Duel.Summon(tp,c,true,e:GetLabelObject())
end
function cm.cfilter(c)
	return c:IsSetCard(0x3f1b)
end
function cm.thfilter(c,tc)
	return aux.IsCodeListed(tc,c:GetCode()) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.cop(e,tp)
	local tc=rsop.SelectSolve(HINTMSG_CONFIRM,tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,{}):GetFirst()
	if not tc then return end
	Duel.ConfirmCards(1-tp,tc)
	rsop.SelectOC("th",true)
	rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{},tc)
end
function cm.tgfilter(c,e)
	return c:IsSetCard(0x3f1b) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and not c:IsCode(e:GetHandler():GetCode())
end
function cm.tgop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil,{},e)
	if tc and tc:IsLocation(LOCATION_GRAVE) and c then
		local e1=rscf.QuickBuff(c,"code",tc:GetCode())
	end
end