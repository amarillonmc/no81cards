--龙血师团-花界魔公子
if not pcall(function() require("expansions/script/c40009469") end) then require("script/c40009469") end
local m,cm = rscf.DefineCard(40009475)
function cm.initial_effect(c)
	local e1,e2,e3 = rsdb.XyzFun(c,m,m+3)
	local e4 = rsdb.ImmueFun(c,m)
	local e5 = rsef.I(c,"des",nil,"des","tg",LOCATION_MZONE,nil,rscost.rmxyz(1),rstg.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
end
function cm.desop(e,tp)
	local c,tc = e:GetHandler() , rscf.GetTargetCard()
	if not tc then return end
	tc:RegisterFlagEffect(m,rsreset.est,0,1)
	local fid = c:GetFieldID()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:RegisterFlagEffect(m+100,rsreset.est,0,1,fid)
	end
	local e1 = rsef.FC({c,tp},EVENT_CHAINING,nil,nil,nil,nil,cm.desscon,cm.dessop)
	e1:SetLabel(fid)
	e1:SetLabelObject(tc)
end
function cm.desscon(e,tp,eg,ep,ev,re)
	local rc=re:GetHandler()
	return rc:GetFlagEffect(m)>0 and rc:IsRelateToEffect(re) and rc == e:GetLabelObject()
end
function cm.dessop(e,tp,eg,ep,ev,re)
	rshint.Card(m)
	if Duel.Destroy(re:GetHandler(),REASON_EFFECT)<=0 then return end
	local c = e:GetOwner()
	if c and c:GetFlagEffectLabel(m+100) == e:GetLabel() then
		local e1 = rscf.QuickBuff(c,"atk+",1800)
	end
end