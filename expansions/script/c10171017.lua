--深渊之主 马努斯
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171017)
function cm.initial_effect(c)
	local e1=rsds.ExtraSummonFun(c,m+2)
	local e2=rsef.FTF(c,EVENT_SPSUMMON_SUCCESS,{m,0},nil,"tk,sp",nil,LOCATION_MZONE,cm.tkcon,nil,cm.tktg,cm.tkop)
	local e3=rsef.SV_IMMUNE_EFFECT(c,rsval.imoe,rscon.excard2(Card.IsCode,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,10171021))
	local e4=rsef.QO(c,nil,{m,2},nil,"atk,def","dcal",LOCATION_MZONE,aux.dscon,rscost.cost(cm.resfilter,"res",LOCATION_ONFIELD),nil,cm.atkop)
	--local e3=rsef.QO(c,nil,{m,1},{1,m},"sp",nil,LOCATION_GRAVE,nil,cm.spcost,rstg.target2(cm.fun,cm.spfilter,"sp"),cm.spop)
end
function cm.tkcfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end 
function cm.tkcon(e,tp,eg)
	return eg:IsExists(cm.tkcfilter,1,nil,tp)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+4,0,0x4011,2000,2500,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,m+4)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
			local e1=rsef.SV_INDESTRUCTABLE({c,token,true},"effect",1,nil,rsreset.est)
			local e2,e3=rsef.SV_CANNOT_BE_MATERIAL({c,token,true},"syn,link",1,nil,rsreset.est)
		end
	end
end
function cm.resfilter(c,e,tp)
	return (c:IsCode(m+4) or c:IsSetCard(0xc335)) and c:IsReleasable() and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.spcost(e,...)
	e:SetLabel(100)
	return rscost.cost(cm.resfilter,"res",LOCATION_MZONE)(e,...)
end
function cm.fun(g,e,tp)
	e:SetLabel(0)
end
function cm.spfilter(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	return e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.resfilter(c)
	return c:IsReleasable() and c:IsCode(10171021)
end
function cm.atkop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	if not c then return end
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",500)
end